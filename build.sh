#!/bin/sh

# Creates a whisper rpm
# Assumptions:
# -> the /git/directory got a whisper directory

GIT_DIR=/git
SOFT_NAME=graphite-web
pushd /${GIT_DIR}/${SOFT_NAME}/
git checkout master
tag=$(git describe --abbrev=0 --tags)
if [ `echo ${tag}|grep "-"` ];then
    tag=$(echo ${tag}|awk -F\- '{print $1}')
fi
popd
pushd /tmp
cp -r /${GIT_DIR}/${SOFT_NAME} ${SOFT_NAME}-${tag}
tar cfz ~/rpmbuild/SOURCES/${SOFT_NAME}-${tag}.tar.gz ${SOFT_NAME}-${tag} 
rm -rf ${SOFT_NAME}-${tag}
popd

cp ${SOFT_NAME}.spec.base ${SOFT_NAME}.spec
sed -i -e "s/%TAG%/${tag}/" ${SOFT_NAME}.spec
sed -i -e "s/%RELEASE%/master/" ${SOFT_NAME}.spec
rpmbuild -ba ${SOFT_NAME}.spec
rm -rf ~/rpmbuild/SOURCES/${SOFT_NAME}-${tag}.tar.gz

cp ~/rpmbuild/RPMS/*/*.rpm /git/myrepo/
createrepo /git/myrepo/
