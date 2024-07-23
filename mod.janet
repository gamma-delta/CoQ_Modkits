#!/usr/bin/env janet

(use cbt-1.0.0)

(use /src/object-blueprints)
(use /src/poptables)


(declare-mod
  "modkits"
  "Modkits"
  "petrak@"
  "0.1.1"
  :description "Modkits let you put mods on an item without any tinkering skills. Github: https://github.com/gamma-delta/CoQ_Modkits"
  :thumbnail "thumbnail.png"
  :steam-id 3294839024)

(generate-xml "ObjectBlueprints.xml" object-blueprints)
(generate-xml "Populations.xml" poptables)
