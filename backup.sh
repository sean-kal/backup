#!/bin/bash
########################################################################
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
########################################################################
# Developer: 		Sean Kalkiewicz
# Github:		https://github.com/sean-kal
# Program Name:		Backup
# Purpose:		Backup the most important files, folders, and programs
# Version:		1.0
# Dependencies: 	Bash shell
#
########################################################################

if [[ $EUID -ne 0 ]]; then
   echo "This program must be run as root" 
   exit
fi

if [ "$0" = sudo ] && [ "$1" = bash ]
then
	{
	param1="$1"
	param2="$2"
	param3="$3"
	}
else
	{
	param1="$0"
	param2="$1"
	param3="$2"
	}
fi

if [ -z "$param2" ] || [ "$param2" = -h ]
then
	{
		echo "Usage: $param1 [-h] [-v] [-b Location of Backup] [-r Location of Backup]"
		echo -e "\nOptions:"
		echo -e "\t-h\tShow help and exit"
		echo -e "\t-v\tShow version and exit"
		echo -e "\t-b\tCreate a backup. If no location is specified, it goes to the backup folder in the program directory"
		echo -e "\t-v\tRestore items from a specified folder"
		echo -e "\nExamples:"
		echo -e "\t./abackup.sh -h"
		echo -e "\t./backup.sh -v"
		echo -e "\t./backup.sh -b"
		echo -e "\t./backup.sh -b /media/username/Backups/My Backups"
		echo -e "\t./backup.sh -r /media/username/Backups/My Backups"
		echo -e "\nReport bugs to skalkiewicz@gmail.com"
		exit
	}
elif [ "$param2" = -v ]
then
	{
		echo -e "\vBackup : Version 1.0\nReport bugs to skalkiewicz@gmail.com"
		exit
	}
elif [ "$param2" = -b ]
then
	{
		check=$(echo $param3 | wc -c)
		check=$(($check-1))
		tmp=$(echo $param3 | cut -c $check)
		if [ $tmp = "/" ]
		then
			{
				echo "Please get rid of the slash as the final character"
				exit
			}
		fi
		
		if [ -z "$param3" ]
		then
			{
				check=$(ls /home/$username/Backup/Backups | grep -c "OLD.USER.dat")
				if [ $check = 1 ]
				then
					{
						echo "You have backups in this folder already"
						echo "Would you like to remove them and then continue?(y/n)"
						read answer

						if [ $answer = y ]
						then
							{
								sudo rm -r /home/$username/Backup/Backups/*
							}
						else
							{
								exit
							}
						fi
					}
				fi
			}
		else
			{
				check=$(ls $param3 | grep -c "OLD.USER.dat")
				if [ $check = 1 ]
				then
					{
						echo "You have backups in this folder already"
						echo "Would you like to remove them and then continue?(y/n)"
						read answer

						if [ $answer = y ]
						then
							{
								sudo rm -r $param3/*
							}
						else
							{
								exit
							}
						fi
					}
				fi
			}
		fi

		echo -e "Backup v1.0\n"

		username=$(whoami)

		if [ -z "$param3" ]
		then
			{
				echo "! LOCATIONS OF BACKED UP FOLDERS AND FILES" >> /home/$username/Backup/Backups/LOCATIONS.dat
				echo "! DO NOT EDIT" >> /home/$username/Backup/Backups/LOCATIONS.dat
				echo "! FOLDERS" >> /home/$username/Backup/Backups/LOCATIONS.dat
			}
		else
			{
				echo "! LOCATIONS OF BACKED UP FOLDERS AND FILES" >> $param3/LOCATIONS.dat
				echo "! DO NOT EDIT" >> $param3/LOCATIONS.dat
				echo "! FOLDERS" >> $param3/LOCATIONS.dat
			}
		fi
	
		echo -e "Backing up installed apps...\n"
		if [ -z "$param3" ]
		then
			{
				dpkg --get-selections > /home/$username/Backup/Backups/Apps.txt
			}
		else
			{
				dpkg --get-selections > $param3/Apps.txt
			}
		fi

		if [ -z "$param3" ]
		then
			{
				echo -e "Backing up important locations...\n"
				echo "Desktop..."
				sudo cp -R /home/$username/Desktop /home/$username/Backup/Backups/Desktop
				echo "Documents..."
				sudo cp -R /home/$username/Documents /home/$username/Backup/Backups/Documents
				echo "Downloads..."
				sudo cp -R /home/$username/Downloads /home/$username/Backup/Backups/Downloads
				echo "Music..."
				sudo cp -R /home/$username/Music /home/$username/Backup/Backups/Music
				echo "Pictures..."
				sudo cp -R /home/$username/Pictures /home/$username/Backup/Backups/Pictures
				echo "Public..."
				sudo cp -R /home/$username/Public /home/$username/Backup/Backups/Public
				echo "Templates..."
				sudo cp -R /home/$username/Templates /home/$username/Backup/Backups/Templates
				echo -e "Videos...\n"
				sudo cp -R /home/$username/Videos /home/$username/Backup/Backups/Videos
			}
		else
			{
				echo -e "Backing up important locations...\n"
				echo "Desktop..."
				sudo cp -R /home/$username/Desktop $param3/Desktop
				echo "Documents..."
				sudo cp -R /home/$username/Documents $param3/Documents
				echo "Downloads..."
				sudo cp -R /home/$username/Downloads $param3/Downloads
				echo "Music..."
				sudo cp -R /home/$username/Music $param3/Music
				echo "Pictures..."
				sudo cp -R /home/$username/Pictures $param3/Pictures
				echo "Public..."
				sudo cp -R /home/$username/Public $param3/Public
				echo "Templates..."
				sudo cp -R /home/$username/Templates $param3/Templates
				echo -e "Videos...\n"
				sudo cp -R /home/$username/Videos $param3/Videos
			}
		fi
		
		c=0
		while : ; do
			if [ $c = 0 ]
			then
				{
					echo "Please specify the locations of your own FOLDERS to be backed up"
					echo -e "\nIf you are done, hit the enter bar without entering anything in"
				}
			fi
			
			read user_defined

			if [ -z "$user_defined" ]
			then
				{
					break
				}
			fi
			
			echo "Backing up $user_defined..."
			
			if [ -z "$param3" ]
			then
				{
					sudo cp -R $user_defined /home/$username/Backup/Backups/
					
					echo $user_defined >> /home/$username/Backup/Backups/LOCATIONS.dat
				}
			else
				{
					sudo cp -R $user_defined $param3

					echo $user_defined >> $param3/LOCATIONS.dat
				}
			fi

			c=$(($c+1))
		done

		if [ -z "$param3" ]
		then
			{
				echo -e "\n" >> /home/$username/Backup/Backups/LOCATIONS.dat
				echo "# FILES" >> /home/$username/Backup/Backups/LOCATIONS.dat
			}
		else
			{
				echo -e "\n" >> $param3/LOCATIONS.dat
				echo "# FILES" >> $param3/LOCATIONS.dat
			}
		fi

		c=0
		while : ; do
			if [ $c = 0 ]
			then
				{
					echo "Please specify the locations of your own FILES to be backed up"
					echo -e "\nIf you are done, hit the enter bar without entering anything in\n"
				}
			fi
			
			read user_defined

			if [ -z "$user_defined" ]
			then
				{
					break
				}
			fi
			
			echo -e "Backing up $user_defined...\n"

			if [ -z "$param3" ]
			then
				{
					sudo cp $user_defined /home/$username/Backup/Backups/

					echo $user_defined >> /home/$username/Backup/Backups/LOCATIONS.dat
				}
			else
				{
					sudo cp $user_defined $param3

					echo $user_defined >> $param3/LOCATIONS.dat
				}
			fi

			c=$(($c+1))
		done
		
		echo -e "Finishing up...\n"

		if [ -z "$param3" ]
		then
			{
				echo $username > /home/$username/Backup/Backups/OLD.USER.dat
			}
		else
			{
				echo $username > $param3/OLD.USER.dat
			}
		fi
		echo "Backup has completed!"
	}
elif [ "$param2" = -r ]
then
	{
		if [ -z "$param3" ]
		then
			{
				echo "You must specify the location of your saved backups"
				exit
			}
		fi

		check=$(ls $param3 | grep -c "OLD.USER.dat")
		if [ $check = 0 ]
		then
			{
				echo "That directory does not contain your backups"
				exit
			}
		fi

		check=$(echo $param3 | wc -c)
		check=$(($check-1))
		tmp=$(echo $param3 | cut -c $check)
		if [ $tmp = "/" ]
		then
			{
				echo "Please get rid of the slash as the final character"
				exit
			}
		fi

		echo -e "Backup v1.0"

		username=$(whoami)

		echo "Restoring backed up apps..."
		dpkg --clear-selections
		sudo dpkg --set-selections < $param3/Apps.txt
		sudo apt-get autoremove
		echo -e "Updating packages...\n"
		sudo apt upgrade

		echo -e "\nRestoring important LOCATIONS...\n"
		echo "Desktop..."
		sudo cp -R $param3/Desktop /home/$username/
		echo "Documents..."
		sudo cp -R $param3/Documents /home/$username/
		echo "Downloads..."
		sudo cp -R $param3/Downloads /home/$username/
		echo "Music..."
		sudo cp -R $param3/Music /home/$username/
		echo "Pictures..."
		sudo cp -R $param3/Pictures /home/$username/
		echo "Public..."
		sudo cp -R $param3/Public /home/$username/
		echo "Templates..."
		sudo cp -R $param3/Templates /home/$username/
		echo -e "Videos...\n"
		sudo cp -R $param3/Videos /home/$username/

		while read -r line; do
			username=$(whoami)
			username_old_len=$(<$param3/OLD.USER.dat | wc -c)

			search=$(echo $line | grep -c "# ")
			if [ $search = 1 ]
			then
				{
					break
				}
			fi

			search=$(echo $line | grep -c "! ")
			if [ $search = 0 ]
			then
				{
					echo "Copying $line..."
					char="/"
					total=$(echo "${line}" | awk -F"${char}" '{print NF-1}')
					total=$(($total+1))
					cutted=$(echo $line | cut -d "/" -f $total)

					len=$(echo $line | wc -c)
					len2=$(echo $cutted | wc -c)
					diff=$(($len-$len2))
					first=$(echo $line | cut -c 1-$diff)

					sudo cp -R $param3/$cutted $first
				}
			fi
		done < $param3/LOCATIONS.dat

		echo -e "\n"

		c=0
		while read -r line; do
			if [ $c = 1 ]
			then
				{
					search=$(echo $line | grep -c "# ")
					if [ $search = 0 ]
					then
						{
							echo "Copying $line..."
							char="/"
							total=$(echo "${line}" | awk -F"${char}" '{print NF-1}')
							total=$(($total+1))
							cutted=$(echo $line | cut -d "/" -f $total)
		
							len=$(echo $line | wc -c)
							len2=$(echo $cutted | wc -c)
							diff=$(($len-$len2))
							first=$(echo $line | cut -c 1-$diff)
		
							sudo cp $param3/$cutted $first
						}
					fi
				}
			fi

			search=$(echo $line | grep -c "# ")
			if [ $search = 1 ]
			then
				{
					c=1
				}
			fi
		done < $param3/LOCATIONS.dat

		echo -e "\nFinishing up...\n"
			sudo rm $param3/OLD.USER.dat
			sudo rm $param3/LOCATIONS.dat
		echo "Restoration has completed!"

		echo -e "\nIt is highly recommended that you rebackup your files at this point"
		echo "Please rerun this program with the backup parameter"
	}
else
	{
		echo -e "\nInvalid option '$1'"
		echo "Type $param1 -h for options"
		exit
	}
fi