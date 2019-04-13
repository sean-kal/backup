# Backup
#############################################################

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Author: Sean Kalkiewicz

#############################################################
About

This tool backs up the most important files, folders, and programs on your
Linux machine.

#############################################################
Requirements

A Linux system with BASH environment.

#############################################################
Usage: ./backup.sh <options> [Location of Backup]

Options:
	-h	Show help and exit
	-v	Show version and exit
	-b	Create a backup. If no location is specified, it goes to the backup folder in the program directory
	-r	Restore items from a specified folder

#############################################################
Examples

./backup.sh -h
./backup.sh -v
./backup.sh -b
./backup.sh -b /media/username/Backups/My Backups
./backup.sh -r /media/username/Backups/My Backups

