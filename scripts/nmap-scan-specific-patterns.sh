#!



TARGETS="scope.txt"
OUTPUT_DIR="scans"


# Scan for NFS Shares
nmap -sV --script rpcinfo,nfs-showmount -iL "${TARGETS}"-p 2049,111 --open -oA "${OUTPUT_DIR}/nmap-nfs-shares"


