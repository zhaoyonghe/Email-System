#!/bin/bash

mkdir -p outputs/00001
mkdir -p outputs/00002
mkdir -p outputs/00003
mkdir -p outputs/00004
mkdir -p outputs/00005
mkdir -p outputs/00006
mkdir -p outputs/00007
mkdir -p outputs/00008
mkdir -p outputs/00009
mkdir -p outputs/00010
mkdir -p outputs/00011
mkdir -p outputs/00012
mkdir -p outputs/00013
mkdir -p outputs/00014
mkdir -p outputs/00015
mkdir -p outputs/00016
mkdir -p outputs/00017
mkdir -p outputs/00018
mkdir -p outputs/00019
mkdir -p outputs/00020
mkdir -p outputs/00021
mkdir -p outputs/00022
mkdir -p outputs/00023
mkdir -p outputs/00024
mkdir -p outputs/00025
mkdir -p outputs/00026
mkdir -p outputs/00027
mkdir -p outputs/00028
mkdir -p outputs/00029
mkdir -p outputs/00030
mkdir -p outputs/00031
mkdir -p outputs/00032
mkdir -p outputs/00033
mkdir -p outputs/00034

users=("addleness" "analects" "annalistic" "anthropomorphologically" "blepharosphincterectomy" "corector" "durwaun" "dysphasia" "encampment" "endoscopic" "exilic" "forfend" "gorbellied" "gushiness" "muermo" "neckar" "outmate" "outroll" "overrich" "philosophicotheological" "pockwood" "polypose" "refluxed" "reinsure" "repine" "scerne" "starshine" "unauthoritativeness" "unminced" "unrosed" "untranquil" "urushinic" "vegetocarbonaceous" "wamara" "whaledom")

for i in outputs/*
do
    for user in ${users[@]}
    do
        echo "$i/$user"
        mkdir -p $i/$user
    done
done