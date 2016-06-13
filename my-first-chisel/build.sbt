name := "chisel-module-template"

version := "1.0"

val chiselVersion = System.getProperty("chiselVersion", "3.0")

scalaVersion := "2.11.7"

resolvers ++= Seq("scct-github-repository" at "http://mtkopone.github.com/scct/maven-repo")

libraryDependencies += "edu.berkeley.cs" %% "chisel" % "latest.release"

