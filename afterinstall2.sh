#! /bin/bash
#
# $Id: afterinstall.sh 57 2014-12-30 19:22:24 Angel $
##
# Angel's script for automatic installation of Gnome and Unity desktots and others in Ubuntu Studio 14.04.1 LTS
#
#v(b.2.01)
#

#
# Copyright (C) 20014 Angel Garcia
#
# This file is a script to install Gnome, Unity and some .deb packages
# in Ubuntu Studio 14.04.1 LTS This file is free software;
# you can redistribute it and/or modify it under the terms of the GNU
# General Public License (GPL) as published by the Free Software
# Foundation, in version 2 as it comes in the "License_en_US.rtf" file
# in the root folder of the script package. This script is distributed
# in the hope that it will be useful, but WITHOUT ANY WARRANTY of any kind.
#

#
# Comments in Spanish
# "###" means parts of code disabled by default becase unused or other reasons
#


#Variables creation
ostype=`uname -s`
osdist=`uname -n`

install_unity=`zenity --question --title="Install Unity" --text="Do you want to install the Unity desktop?"`

install_unity_greeter=`zenity --question --title="Configure Unity greeter" --text="Do you want to use the unity greeter instead of the ubuntu studio one"`

install_gnome=`zenity --question --title="Install GNOME" --text="Do you want to install the GNOME desktop?"`

# Test if is running in Linux Ubuntu Studio
if test "$ostype" != "Linux" && test "$osdist" != "ubuntu-studio" ; then
  echo "Ubuntu Studio not detected."
  echo "This script was made to work only with ubuntu studio"
  exit 1
fi




# Añadir repositorios de Ubuntu (partners, universe y multiverse)

zenity   --warning --text=" ACTIVE REPOSITORIOS DE LA PRIMERA Y SEGUNDA PESTAÑA \n Canonical partners, Universe and Multiverse"

####sudo software-properties-gtk
###sudo /usr/bin/python /usr/bin/software-properties-gtk --open-tab=1
###sudo apt-get update


#this could be changed by "software-properties-gtk --open-tab=1"
if `sudo /usr/bin/python /usr/bin/software-properties-gtk --open-tab=1`
	then
		echo "Done"
	else
		echo "not successfull"
		echo "trriying it other way"
		sudo software-properties-gtk --open-tab=1
fi

	# ORDEN DE INSTALACION
#	unity
#	unity-greeter
#	ubuntu-desktop
#	gnome-session-flashback
#	gnome
#	gnome-shell


sudo apt-get install -y unity #instalar  unity
sudo apt-get install -y unity-greeter #instala el greeter de unity
sudo apt-get install -y ubuntu-desktop #instalar ubuntu-desktop
sudo unity-greeter

zenity   --warning --text=" Seleccione Lightdm si se le pide!!! "
sudo apt install gnome-session-flashback
####sudo apt-get install gnome #instala gnome
###sudo apt-get install gnome-shell
###sudo apt-get install gnome-shell-extensions

#instalacion avanzada de gnome
if `zenity --question --text="Instlar Repositorios especificos de Gnome 3/ GNOME Shell?"`
	then
		sudo add-apt-repository ppa:ricotz/testing -y
		sudo add-apt-repository ppa:gnome3-team/gnome3 -y
		sudo add-apt-repository ppa:gnome3-team/gnome3-staging -y
		sudo apt update
		sudo apt-get install -y gnome
		sudo apt-get install -y gnome-shell
		sudo apt-get install -y gnome-shell-extensions
		sudo apt install -y gnome-tweak-tool
	else
		sudo apt update
		sudo apt-get install -y gnome
		sudo apt-get install -y gnome-shell
		sudo apt-get install -y gnome-shell-extensions
		sudo apt install gnome-tweak-tool -y
fi




	# copia archivo de configuracion necesario para el funcionamiento de unity-greeter, NECESARIO!!
sudo cp unity-greeter.conf /etc/lightdm/unity-greeter.conf

###	# crea backup del archivo de configuracion de lightdm de ubuntu studio, "just in case" para posible recuperacion
###sudo cp /etc/lightdm/lightdm.conf.d/10-ubuntustudio.conf /etc/lightdm/lightdm.conf.d/10-ubuntustudio.conf.bak
### 

sudo cp -b 10-ubuntustudio.conf /etc/lightdm/lightdm.conf.d/10-ubuntustudio.conf #copia archivo de configuracion nuevo y crea backup, lo cual hace inecesario el anterior comando




# Ask to install Ubuntu-tweak

if `zenity --question --text="Instlar Ubuntu Tweak"`
	then 
		sudo add-apt-repository ppa:tualatrix/ppa -y # añadir repositorio de ubuntu-tweak
		sudo apt-get update
		sudo apt-get install -y ubuntu-tweak # Instala ubuntu-tweak
fi



# Ask to install Unity-tweak-tool

if `zenity --question --text="Instlar Unity Tweak Tool"`
	then
		sudo aspt-get install -y unity-tweak-tool # Instala unity-tweak-tool
fi



# Ask to install Grub Customizer

if `zenity --question --text="Instlar Grub Customizer? \n (editor del cargador de arranque)"`
	then
		#Añadir los repositorios con el comando:
		sudo add-apt-repository ppa:danielrichter2007/grub-customizer -y
		#Actualizar los repositorios con:
		sudo apt-get update
		#Instalar la aplicación:
		sudo apt-get install grub-customizer -y
fi



	# Instalacion de Skype

if `zenity --question --text="Instlar Skype"`
	then
		sudo dpkg --add-architecture i386 #añade arquitectura
		sudo apt-get update # Recarga paquetes
		sudo apt-get install skype -y # Instala skype desde los repositorios
fi



###
###	# Descarga en local e instalacion de Google Chrome
###wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb # Descarga archivo
###sudo dpkg -i google-chrome-stable_current_amd64.deb # Attemp tp install
###sudo apt-get install -f # Encuentra dependencias rotas y las arregla
###sudo dpkg -i google-chrome-stable_current_amd64.deb # Finaliza la instalacion de  google chrome
###sudo rm -f google-chrome-stable_current_amd64.deb # Borrado del paquete ya instalado
###

	# Descarga en tmp e instalacion de Google Chrome

if `zenity --question --text="Instlar Google Chrome"`
	then
		wget -O /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb # Descarga archivo
		sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb  -y # Attemp to install
		sudo apt-get install -f -y # Encuentra dependencias rotas y las instala
		sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb  -y # Finaliza la instalacion de  google chrome

fi



# Instalar JAVA
if `zenity --question --text="Instlar JAVA"`
	then
		sudo add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" -y
		sudo add-apt-repository "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" -y
		sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
		sudo apt-get update
		sudo apt-get install oracle-java8-installer -y
		sudo apt-get install oracle-java8-set-default -y
fi



# Descarga en tmp e instalacion de Steam

if `zenity --question --text="Instlar Steam"`
	then
		wget -O /tmp/steam.deb http://media.steampowered.com/client/installer/steam.deb # Descarga archivo
		sudo dpkg -i /tmp/steam.deb # Attemp to install
		sudo apt-get install -f # Encuentra dependencias rotas y las instala
		sudo dpkg -i /tmp/steam.deb # Finaliza la instalacion de  Steam

fi



# Instalar controladores privativos

if `zenity --question --text="Instlar Controladores privativos automaticamente?"`
	then
		sudo ubuntu-drivers autoinstall
fi



#Proceder a instalar complementos de NTFS
sudo apt-get install -y ntfs-3g ntfs-config



zenity --info --text="Instalacion concluida"
exit
