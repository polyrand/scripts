
#Port sanner

for i in {1..10000}; do (echo </dev/tcp/192.168.0.1/$i) &>/dev/null && echo -e "\n[+] Open port
    at\n:\t$i" || echo -n "."; done

# Rotate videos 90º
mkdir rotated; for v in *.3gp; do ffmpeg -i $v -vf transpose=2 -vcodec ffv1 rotated/${v/3gp/avi} ; done
