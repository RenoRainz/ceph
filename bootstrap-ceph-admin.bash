useradd -d /home/cephuser -s /bin/bash -m cephuser
echo "cephuser:cephuser" | chpasswd
echo "cephuser ALL = (root) NOPASSWD:ALL" | tee /etc/sudoers.d/cephuser
chmod 0440 /etc/sudoers.d/cephuser

mkdir /home/cephuser/.ssh
echo "-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAqHPrOehLl+w11EUQmxons2spykUvDEVqIJEjL8ReGejPnm0R
iUxZKBsZRBngR+R3/sk3zP0CMsCI/7+SPD4u0DWQxNrbSLnJ5aMhZzBx2VUxe2pf
yYy6mAGnq2KUPcgrgaBYxCnROJtOJgkq4N07JO7enlgZ4i6k3Qg6+GYrgL3+H0jx
3GvtyafKdmpZdy5p8v3aGMQ4abnL960N1AMfiB9O6yyVOHiUjFqsBkc9DWWNaglg
cpfOe3T/RBTIl1NYPDrQ5wGaO1ddO1egwnOh1QXYhi8+WHba26uQdkh8YMyk4CRJ
n3oXGV6jXqLNHIX+NOeqHAhoNQr5P8Vn6PJpWQIDAQABAoIBAQCbpbgkYnJuptA6
GbK1TZ5/VrZfcjt9oCnme5TCjzPPxuEH5ol8jnIW76sR1ML6Sq1hW3VW0DSWxnYP
sWgih+ZjdgsVCY/yi9B0gZ3cpdOcV+6HtYtaRNEooObXIhgNWgZxGMLMRkNOhZnY
5UGcUm5SuvAx6P/JkQW+QduTJ3xs0B/dZBrWRKCQYZlNrj65QibY573n4tSVjnMh
V1PPkvJYG8iVAaZH4ZE3eSz83vkWZHiWsFzjZXIIgukv7kLe9/Hbjn14oLAPXanu
aKWvWd70ubasaTQVUMtoDzQIDekpATQwAd/xA/UOS3HNsXQ1Zk13F9ZpSWJ51I0p
cazr+nHNAoGBAN8jVwk9+h1ZYE6TgSa7QtAI7bDmxAN1EAXuxaHhA1gl5cSedmoS
vnzzY4cHWtPsKCz9AkgZPNIdNxBAloROylDfVfuNPOU+f0KGwLT2TddBGnOiT6hf
39YyIcWOgjcqpljBjdM1K7bdhtUUxAAiEAeYCT+TaKAH3SlgsIGve9ATAoGBAMFC
27NITUSE2ZB+mwDkqW9qFXnLnEHBUKhr7a+wFy3CEk4362JFxKxgv/bk35fGdGlA
ms299zr+03sOeGZTsU0ep3y05rkn4+6JGjY7bWi9tdmwTUfPSG3T5EDqqpiIa675
1C5St3+Hgo+TieljYNWlAoNevhg1IYFu6ZUJHYZjAoGBAJBrfhykOWqfez7AJ3oa
/25IKRcy9LDMJnfAh7dzPEfkF2d/rGKRCSs0GDm/3+CD26jqhHyHoR7Y+9eQBhtS
J43aTvtF+aDiJ1m2f6lgNRdZsrYe2nG+w9ANmGAWEV+FQi7170ZBBq8PiAIHs6fm
Y/uWQn4ceT4CePkb9IGrQ3ZzAoGAem0MGCp5KCqwWCSbtJkl7HpbWGhveAgqPEcC
rwTx6f7C8eHirsJbsIcplBGwwsjo/bP7XNI2R50eAxpLkyb5bk049Hr0nd5zOayI
ekpzKKLlDB3vFspsq4ZLVgRSRYZGEPYaP64OqC8DukhQWRSnRy/cw7PE4DjoHMJS
HiNEHNkCgYEAhJIplThG8DKrYB5XI5nmDm6baI3b3PPxdDrJud93iaz3NwchKpOm
ZXVUMqjKV3ZylnXcZ0UChV75Z5HhJmhUcRiHlWWP4KRKl+iUxKB5aYoUwxXYNN+S
eaBbGmdpfwN4tWDsS+jhCiFmN4h8DzZwDp/ARHQup+BuzsjUYIrlFZg=
-----END RSA PRIVATE KEY-----
" >  /home/cephuser/.ssh/id_rsa

echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCoc+s56EuX7DXURRCbGiezaynKRS8MRWogkSMvxF4Z6M+ebRGJTFkoGxlEGeBH5Hf+yTfM/QIywIj/v5I8Pi7QNZDE2ttIucnloyFnMHHZVTF7al/JjLqYAaerYpQ9yCuBoFjEKdE4m04mCSrg3Tsk7t6eWBniLqTdCDr4ZiuAvf4fSPHca+3Jp8p2all3Lmny/doYxDhpucv3rQ3UAx+IH07rLJU4eJSMWqwGRz0NZY1qCWByl857dP9EFMiXU1g8OtDnAZo7V107V6DCc6HVBdiGLz5Ydtrbq5B2SHxgzKTgJEmfehcZXqNeos0chf4056ocCGg1Cvk/xWfo8mlZ cephuser@ceph-admin" > /home/cephuser/.ssh/id_rsa.pub

chown -R cephuser:cpehuser /home/cephuser

echo "172.16.1.111 ceph-osd-1.internal ceph-osd-1
172.16.1.112 ceph-osd-2.internal ceph-osd-2
172.16.1.113 ceph-osd-3.internal ceph-osd-3
172.16.2.111 ceph-osd-1.storage
172.16.2.112 ceph-osd-2.storage
172.16.2.113 ceph-osd-3.storage
" > /etc/hosts

wget -q -O- 'https://download.ceph.com/keys/release.asc' | sudo apt-key add -
echo deb http://download.ceph.com/debian-hammer/ $(lsb_release -sc) main | sudo tee /etc/apt/sources.list.d/ceph.list
apt-get update && apt-get -y upgrade && apt-get install -y ceph-deploy