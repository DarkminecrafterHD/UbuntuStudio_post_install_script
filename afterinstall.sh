#! /bin/bash
#
# $Id: afterinstall.sh 59 2015-5-23 13:13 Angel $
##
# Angel's script for automatic installation of Gnome and Unity desktots and others in Ubuntu Studio 14.04.1 LTS
#
# $version: b.2.04
#

#
# Copyright (C) 20014 Angel Garcia
#
# This file is a script to install Gnome, Unity and some .deb packages
# in Ubuntu Studio 14.04.1 LTS This file is free software;
# you can redistribute it and/or modify it under the terms of the GNU
# General Public License (GPL) as published by the Free Software
# Foundation, in version 2 as it comes in the "LICENSE" file
# in the root folder of the script package. This script is distributed
# in the hope that it will be useful, but WITHOUT ANY WARRANTY of any kind.
#

#
# Comments in Spanish
# "###" means parts of code disabled by default becase unused or other reasons
#

if ! [ $(whoami) == "root" -a $(uname -n) != "Linux" -a $(uname -r) != "ubuntu-studio"] # Test if is running in Linux Ubuntu Studio and root
	then
	

	if `zenity --question --title="Install Unity" --text="Do you want to install the Unity desktop?"`
		then;	install_unity=true
		else;	install_unity=false
	fi


	if `zenity --question --title="Configure Unity greeter" --text="Do you want to use the unity greeter instead of the ubuntu studio one"`
		then	install_unity_greeter=true
		else	install_unity_greeter=false
	fi

	if `zenity --question --title="Install GNOME" --text="Do you want to install the GNOME desktop?"`
		then	install_gnome=true
		else	install_gnome=false
	if `zenity --question --title="Install NTFS support" --text="Do you want to install ntfs-3g and ntfs-config packages?"`
		then	install_ntfs=true
		else	install_ntfs=false
	fi






	# Añadir repositorios de Ubuntu (partners, universe y multiverse)

	zenity   --warning --text=" ACTIVE REPOSITORIOS DE LA PRIMERA Y SEGUNDA PESTAÑA \n Canonical partners, Universe and Multiverse"

	#### software-properties-gtk
	### /usr/bin/python /usr/bin/software-properties-gtk --open-tab=1
	### apt-get update


	#this could be changed by "software-properties-gtk --open-tab=1"
	if `/usr/bin/python /usr/bin/software-properties-gtk --open-tab=1`
		then
			echo "Done"
		else
			echo "not successfull"
			echo "trriying it other way"
			software-properties-gtk --open-tab=1
	fi

	##### ORDEN DE INSTALACION
	#	unity
	#	unity-greeter
	#	ubuntu-desktop
	#	gnome-session-flashback
	#	gnome
	#	gnome-shell

	if [ $install_unity == true ]
		then
			apt-get install -y unity #instalar  unity
			apt-get install -y unity-greeter #instala el greeter de unity
			apt-get install -y ubuntu-desktop #instalar ubuntu-desktop
			unity-greeter
	fi
	
	if [ $install_gnome == true ]
		then
			zenity   --warning --text=" Seleccione Lightdm si se le pide!!! "
			apt-get install gnome-session-flashback
				#### apt-get install gnome #instala gnome
				### apt-get install gnome-shell
				### apt-get install gnome-shell-extensions

						# Deleted feature (no recomended to use, if you do that, is at your own risk)
						#	#instalacion avanzada de gnome
						#	if `zenity --question --text="Instlar Repositorios especificos de Gnome 3/ GNOME Shell?\nNo recomendado, funciona igualmente."`
						#		then
						#			### add-apt-repository ppa:ricotz/testing -y
						#			### add-apt-repository ppa:gnome3-team/gnome3 -y
						#			### add-apt-repository ppa:gnome3-team/gnome3-staging -y
						#
						#			add-apt-repository "deb http://ppa.launchpad.net/gnome3-team/gnome3/ubuntu trusty main"
						#			add-apt-repository "deb-src http://ppa.launchpad.net/gnome3-team/gnome3/ubuntu trusty main"
						#			apt-get update
						#			apt-get install -y gnome
						#			apt-get install -y gnome-shell
						#			apt-get install -y gnome-shell-extensions
						#			apt-get install -y gnome-tweak-tool
						#		else
						#			apt-get update
						#			apt-get install -y gnome
						#			apt-get install -y gnome-shell
						#			apt-get install -y gnome-shell-extensions
						#			apt-get install gnome-tweak-tool -y
						#	fi
							
				apt-get update
				apt-get install -y gnome
				apt-get install -y gnome-shell
				apt-get install -y gnome-shell-extensions
				apt-get install gnome-tweak-tool -y
	fi

	if [ $install_unity_greeter == true ]
		then
			# copia archivo de configuracion necesario para el funcionamiento de unity-greeter, NECESARIO!!
			cp unity-greeter.conf /etc/lightdm/unity-greeter.conf

			cp -b 10-ubuntustudio.conf /etc/lightdm/lightdm.conf.d/10-ubuntustudio.conf #copia archivo de configuracion nuevo y crea backup, lo cual hace inecesario el anterior comando
	fi

	
	# Ask to install Ubuntu-tweak
	if `zenity --question --text="Instlar Ubuntu Tweak"`
		then 
			add-apt-repository ppa:tualatrix/ppa -y # añadir repositorio de ubuntu-tweak
			apt-get update
			apt-get install -y ubuntu-tweak # Instala ubuntu-tweak
	fi



	# Ask to install Unity-tweak-tool
	if `zenity --question --text="Instlar Unity Tweak Tool"`
		then
			apt-get install -y unity-tweak-tool # Instala unity-tweak-tool
	fi



	# Ask to install Grub Customizer
	if `zenity --question --text="Instlar Grub Customizer? \n (editor del cargador de arranque)"`
		then
			#Añadir los repositorios con el comando:
			add-apt-repository ppa:danielrichter2007/grub-customizer -y
			#Actualizar los repositorios con:
			apt-get update
			#Instalar la aplicación:
			apt-get install grub-customizer -y
	fi



	# Instalacion de Skype
	if `zenity --question --text="Instlar Skype"`
		then
			dpkg --add-architecture i386 #añade arquitectura
			apt-get update # Recarga paquetes
			apt-get install skype -y # Instala skype desde los repositorios
	fi



	# Descarga en tmp e instalacion de Google Chrome
	if `zenity --question --text="Instlar Google Chrome"`
		then
			wget -O /tmp/google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb # Descarga archivo
			dpkg -i /tmp/google-chrome-stable_current_amd64.deb  -y # Attemp to install
			apt-get install -f –fix-missing -y # Encuentra dependencias rotas y las instala
			dpkg -i /tmp/google-chrome-stable_current_amd64.deb  -y # Finaliza la instalacion de  google chrome

	fi



	# Instalar JAVA
	if `zenity --question --text="Instlar JAVA"`
		then
			add-apt-repository "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" -y
			add-apt-repository "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" -y
			apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
			apt-get update
			apt-get install oracle-java8-installer -y
			apt-get install oracle-java8-set-default -y
	fi



	# Descarga en tmp e instalacion de Steam
	if `zenity --question --text="Instlar Steam"`
		then
			wget -O /tmp/steam.deb http://media.steampowered.com/client/installer/steam.deb # Descarga archivo
			dpkg -i /tmp/steam.deb # Attemp to install
			apt-get install -f # Encuentra dependencias rotas y las instala
			dpkg -i /tmp/steam.deb # Finaliza la instalacion de  Steam

	fi



	# Instalar controladores privativos
	if `zenity --question --text="Instlar Controladores privativos automaticamente?"`
		then
			ubuntu-drivers autoinstall
	fi



	#Proceder a instalar complementos de NTFS
	if [ $install_ntfs == true ]
		then
			apt-get install -y ntfs-3g ntfs-config
	fi


	#Finished Instalation
	zenity --info --text="Instalacion concluida"
	
	else
		if [ $(uname -n) != "Linux" -a $(uname -r) != "ubuntu-studio"]
			then
				echo " _-====================================================-_ "
				echo " | This script was made to work only with Ubuntu Studio | "
				echo " \======================================================/ "
		fi
		if ! [ $(whoami) == "root" ]
			then
				echo "You should run it as root"
				sudo 'sh afterinstall.sh'
		fi
fi
