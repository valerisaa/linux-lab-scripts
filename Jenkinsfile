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

        stage('Build RPM') {
            agent {
                label 'agent-1'
            }
            steps {
                unstash 'source'
                sh '''
                    mkdir -p "$WORKSPACE/.rpmbuild"/{BUILD,RPMS,SOURCES,SPECS,SRPMS}

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
