#!/usr/bin/bash

create_partition(){


lsblk

read -p "Select device:" name

fdisk /dev/$name

read -p "Do you finish setting partition ? Yes/No " yn

case $yn in
    [Yy]* ) return 0;;
    [Nn]* ) return 1;;

    esac
}


while true; do

    if create_partition; then
        echo "Created successfully partition";
    else
        break;
    fi

done