rm -rf ~/rpmbuild/RPMS/*
NOSE_EXCLUDE=.* make rpm || { echo "Build Error"; exit 1; }
service vdsmd stop
yum remove -y vdsm\*
yum install -y ~/rpmbuild/RPMS/{noarch,x86_64}/* &&
sed 's/^\#\ ssl\ \=\ true/ssl\ \=\ false/' -i /etc/vdsm/vdsm.conf &&
systemctl --system daemon-reload &&
vdsm-tool configure --module libvirt --force &&
service vdsmd start
