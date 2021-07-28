setxkbmap fr
xset +fp /home/svandeca/.fonts&
xset +fp /usr/local/share/fonts/powerline-fonts&
xset fp rehash
bash .dwm/autostart.sh &
exec dwm
