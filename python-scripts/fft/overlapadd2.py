"""
Copyright: https://gist.github.com/fasiha/1c46cf98b6b43967b139
"""

import numpy as np
from numpy.fft import fft2, ifft2


def overlapadd2(Amat, Hmat, L=None, Nfft=None, y=None, verbose=False):
    """
    Fast two-dimensional linear convolution via the overlap-add method.

    The overlap-add method is well-suited to convolving a very large array,
    `Amat`, with a much smaller filter array, `Hmat` by breaking the large
    convolution into many smaller `L`-sized sub-convolutions, and evaluating
    these using the FFT. The computational savings over the straightforward
    two-dimensional convolution via, say, scipy.signal.convolve2d, can be
    substantial for large Amat and/or Hmat.

    Parameters
    ----------
    Amat, Hmat : array_like
        Two-dimensional input arrays to be convolved. For computational
        purposes, Amat should be larger.
    L : sequence of two ints, optional
        Length of sub-convolution to use. This should ideally be as large as
        possible to obtain maximum speedup: that is, if you have the memory to
        compute the linear convolution using FFT2, i.e., replacing spatial
        convolution with frequency-domain multiplication, then let `L =
        np.array(Amat.shape) + np.array(Hmat.shape) - 1`. Usually, though, you
        are considering overlap-add because you can't afford a batch transform
        on your arrays, so make `L` as big as you can.
    Nfft : sequence of two ints, optional
        Size of the two-dimensional FFT to use for each `L`-sized
        sub-convolution. If omitted, defaults to the next power-of-two, that
        is, the next power-of-two on or after `L + np.array(Hmat.shape) - 1`.
        If you choose this default, try to avoid `L` such that this minimum, `L
        + np.array(Hmat.shape) - 1`, is just a bit greater than a power-of-two,
        since you'll be paying for a 4x larger FFT than you need.
    y : array_like, optional
        Storage for the output. Useful if using a memory-mapped file, e.g.
    verbose : boolean, optional
        If True, prints a message for each `L`-sized subconvolution.

    Returns
    -------
    y : same as passed in, or ndarray if no `y` passed in
        The `np.array(Amat.shape) + np.array(Hmat.shape) - 1`-sized
        two-dimensional array containing the linear convolution. Should be
        within machine precision of, e.g., `scipy.signal.convolve2d(Amat,
        Hmat, 'full')`.

    Raises
    ------
    ValueError if `L` and `Nfft` aren't two-element, and too small: both
    elements of `L` must be greater than zero, and `Nfft`'s must be greater
    than `L + np.array(Hmat.shape) - 1`. Also if `Amat` or `Hmat` aren't
    two-dimensional arrays, or if `y` doesn't have the correct size to store
    the output of the linear convolution.

    References
    ----------
    Wikipedia is only semi-unhelpful on this topic: see "Overlap-add method".
    """
    M = np.array(Hmat.shape)
    Na = np.array(Amat.shape)

    if y is None:
        y = np.zeros(M + Na - 1, dtype=Amat.dtype)
    elif y.shape != tuple(M + Na - 1):
        raise ValueError('y given has incorrect dimensions', M + Na - 1)

    if L is None:
        L = M * 100
    else:
        L = np.array(L)

    if Nfft is None:
        Nfft = 2 ** np.ceil(np.log2(L + M - 1)).astype(int)
    else:
        Nfft = np.array(Nfft, dtype=int)

    if not (np.all(L > 0) and L.size == 2):
        raise ValueError('L must have two positive elements')
    if not (np.all(Nfft >= L + M - 1) and Nfft.size == 2):
        raise ValueError('Nfft must have two elements >= L + M - 1 where '
                         'M = Hmat.shape')
    if not (Amat.ndim <= 2 and Hmat.ndim <= 2):
        raise ValueError('Amat and Hmat must be 2D arrays')

    Hf = fft2(Hmat, Nfft)

    (XDIM, YDIM) = (1, 0)
    adjust = lambda x: x                           # no adjuster
    if np.isrealobj(Amat) and np.isrealobj(Hmat):  # unless inputs are real
        adjust = np.real                           # then ensure real
    start = [0, 0]
    endd = [0, 0]
    while start[XDIM] <= Na[XDIM]:
        endd[XDIM] = min(start[XDIM] + L[XDIM], Na[XDIM])
        start[YDIM] = 0
        while start[YDIM] <= Na[YDIM]:
            if verbose:
                print(start)

            endd[YDIM] = min(start[YDIM] + L[YDIM], Na[YDIM])
            yt = adjust(ifft2(Hf * fft2(Amat[start[YDIM] : endd[YDIM],
                        start[XDIM] : endd[XDIM]], Nfft)))

            thisend = np.minimum(Na + M - 1, start + Nfft)
            y[start[YDIM] : thisend[YDIM], start[XDIM] : thisend[XDIM]] += (
                yt[:(thisend[YDIM] - start[YDIM]),
                    :(thisend[XDIM] - start[XDIM])])
            start[YDIM] += L[YDIM]
        start[XDIM] += L[XDIM]
    return y


def test():
    from scipy.signal import convolve2d
    A = np.random.randn(33, 55)
    H = np.random.randn(4, 5)
    gold = convolve2d(A, H)
    assert(np.allclose(gold, overlapadd2(A, H, L=[12, 12])))
    assert(np.allclose(gold, overlapadd2(A, H, L=[12, 120])))
    assert(np.allclose(gold, overlapadd2(A, H, L=[90, 120])))

    assert(np.allclose(gold, overlapadd2(H, A, L=[190, 220])))
    assert(np.allclose(gold, overlapadd2(H, A, L=[1, 1])))

    assert(np.allclose(gold, overlapadd2(H, A)))
    assert(np.allclose(gold, overlapadd2(A, H)))

    assert(np.allclose(convolve2d(A.T, H.T),
                       overlapadd2(A.T, H.T, L=[190, 220])))

    A = np.random.randn(33, 55) + 1j * np.random.randn(33, 55)
    H = np.random.randn(4, 5) + 1j * np.random.randn(4, 5)
    gold = convolve2d(A, H)
    assert(np.allclose(gold, overlapadd2(H, A)))
    assert(np.allclose(gold, overlapadd2(A, H)))

    print('Test passed!')


if __name__ == '__main__':
    test()
