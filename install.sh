#!/usr/bin/bash

create_partition(){

lsblk

read -p "Select device (e.g. sda): " name

fdisk /dev/$name

read -p "Do you finish setting partition ? Yes/No " yn

case $yn in
    [Yy]* ) return 0;;
    [Nn]* ) return 1;;

    esac
}

set_partition(){
echo '== Create partition =='
while true; do

    if create_partition; then
        echo "Created successfully partition";
	break;
    fi

done


}


set_format_partition(){

fdisk -l | grep '^/dev/'

read -p 'Select partition ( e.g. sda1): ' name

declare -a list=(
"1) ext4 "
"2) ext3 "
"3) xfs "
"4) ntfs "
"Or some other"
)

for fst in  "${list[@]}"
do
 	echo "$fst"
done

read -p "Select type fs: " fs


case $fs in 
	1 ) fst="ext4" ;; 
	2 ) fst="ext3" ;;
	3 ) fst="xfs" ;;
	4 ) fst="ntsf" ;;
	* ) fst=$fs ;;

	esac

mkfs.$fst /dev/$name

read -p 'Complete format partition ? Yes/No ' res

case $res in
	[Yy]* ) return 0;;
	[Nn]* ) return 1;;
	* ) return 1;;
esac

}

format_partition(){
echo '== Format partition =='
while true; do
	if set_format_partition; then
		echo "Format successfyllu partition";
		break;
	fi

done

}

swap(){

fdisk -l | grep '^/dev/'
read -p 'Select partition for swap: ' name

mkswap /dev/$name
swapon /dev/$name


read -p 'Complete setting swap? Yes/No ' res

case $res in
	[Yy]* ) return 0;;
	[Nn]* ) return 1;;
	* ) return 1;;
esac


}
set_swap(){
while true; do
echo '== Setting swap == '
	if swap; then
		echo 'Set successfyllu swap';
		break;
	fi

done
}


mount_system(){
echo '=== Mount ===='
fdisk -l | grep '^/dev/'

read -p 'Input partition for root (e.g sda): ' root
mount /dev/$root /mnt


read -p 'Input partition for home (e.g sda):' home
mkdir /mnt/home
mount /dev/$home /mnt/home

echo 'Finish mount system'

return 0;
}


install_base(){
pacstrap /mnt base

echo '=== Complete install base ==='

genfstab -U /mnt >> /mnt/etc/fstaba

echo '=== Complete execute genfstab ==='

arch-chroot /mnt

echo '=== Complete login to root ==='

}

install(){
declare -a list=(
"1) Create partition"
"2) Format partition"
"3) Set swap"
"4) Mount system"
"5) Install base system"
"0) Exit"
)

while true; do 
echo '=== Install Arch ==='

for op in "${list[@]}"
do
	echo "$op"
done

read -p 'Select stage: ' stage

case $stage in 
	1 ) create_partition;;
	2 ) format_partition;;
	3 ) swap;;
	4 ) mount_system;;
	5 ) install_base;;
	0 ) echo 'Mision complete' 
	    return;;

	* ) echo 'Invalid input';;
esac

done
}


install
