pipeline {
    agent none

    environment {
        PACKAGE_NAME = 'count-files'
        RPM_VERSION = '2.0'
        DEB_VERSION = '1.0'
    }

    stages {
        stage('Checkout') {
            agent {
                label 'agent-1'
            }
            steps {
                checkout scm
                sh 'ls -la'
                stash name: 'source', includes: 'count_files.sh,lab4-rpm/**,lab5-deb/**'
            }
        }

        stage('Test Script') {
            agent {
                label 'agent-1'
            }
            steps {
                unstash 'source'
                sh 'bash -n count_files.sh'
                sh 'bash count_files.sh'
            }
        }
        stage('ShellCheck') {
            agent {
                label 'agent-1'
            }
            steps {
                unstash 'source'
                sh 'shellcheck count_files.sh'
            }
        }
        stage('Build Packages') {
            parallel {

        stage('Build RPM') {
            agent {
                label 'agent-1'
            }
            steps {
                unstash 'source'
                sh '''
                    mkdir -p "$WORKSPACE/.rpmbuild/BUILD" \
         "$WORKSPACE/.rpmbuild/RPMS" \
         "$WORKSPACE/.rpmbuild/SOURCES" \
         "$WORKSPACE/.rpmbuild/SPECS" \
         "$WORKSPACE/.rpmbuild/SRPMS"

                    cp lab4-rpm/SPECS/count-files.spec \
                       "$WORKSPACE/.rpmbuild/SPECS/"

                    cp lab4-rpm/SOURCES/count_files.1 \
                       "$WORKSPACE/.rpmbuild/SOURCES/"

                    cp lab4-rpm/SOURCES/count-files.conf \
                       "$WORKSPACE/.rpmbuild/SOURCES/"

                    tar czf "$WORKSPACE/.rpmbuild/SOURCES/${PACKAGE_NAME}-${RPM_VERSION}.tar.gz" \
                        -C lab4-rpm "${PACKAGE_NAME}-${RPM_VERSION}"

                    rpmbuild -ba \
                        --define "_topdir $WORKSPACE/.rpmbuild" \
                        "$WORKSPACE/.rpmbuild/SPECS/count-files.spec"

                    cp "$WORKSPACE"/.rpmbuild/RPMS/noarch/*.rpm "$WORKSPACE/"
                '''

                stash name: 'rpm-package', includes: '*.rpm'
            }
        }

        stage('Build DEB') {
            agent {
                label 'agent-2'
            }
            steps {
                unstash 'source'
                sh '''
                    cd lab5-deb
                    dpkg-buildpackage -us -uc -b
                '''

                stash name: 'deb-package', includes: '*.deb'
            }
        }
    }
 }
        stage('Test RPM Installation') {
            agent {
                docker {
                    image 'fedora:latest'
                    label 'built-in'
                    args '-u root'
                }
            }
            steps {
                unstash 'rpm-package'
                sh '''
                    rpm -ivh --nosignature count-files-2.0-1.noarch.rpm
                    count_files
                    rpm -e count-files
                '''
            }
        }
        stage('Test DEB Installation') {
            agent {
                docker {
                    image 'ubuntu:latest'
                    label 'built-in'
                    args '-u root'
                }
            }
            steps {
                unstash 'deb-package'
                sh '''
                    dpkg -i count-files_1.0-1_all.deb
                    count_files
                    dpkg -r count-files
                '''
            }
        }

        stage('Archive Packages') {
            agent {
                label 'agent-1'
            }
            steps {
                unstash 'rpm-package'
                unstash 'deb-package'

                archiveArtifacts artifacts: '*.rpm,*.deb',
                                 fingerprint: true
            }
        }
    }

    post {
        success {
            echo 'Build completed successfully!'
        }

        failure {
            echo 'Build failed!'
        }
    }
}
