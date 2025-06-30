pipeline {
    agent any

    environment {
        PROJECT_NAME = "ascenttt"
        SCHEME_NAME = "ascenttt"
        PROJECT_FILE = "ascenttt.xcodeproj"
        EXPORT_OPTIONS_PLIST = "ExportOptions.plist"
    }

    stages {
        stage('Checkout') {
            steps {
               git branch: 'tesJenkins', credentialsId: 'git-clima-credential', url: 'git@github.com:morahakim/SwoozApp.git/'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh '''
                if [ -f "Podfile" ]; then
                    pod install
                fi
                '''
            }
        }

        stage('Build IPA') {
            steps {
                sh '''
                xcodebuild clean -project "$PROJECT_FILE" -scheme "$SCHEME_NAME" -configuration Release
                xcodebuild archive -project "$PROJECT_FILE" -scheme "$SCHEME_NAME" -archivePath build/$PROJECT_NAME.xcarchive -destination 'generic/platform=iOS'
                xcodebuild -exportArchive -archivePath build/$PROJECT_NAME.xcarchive -exportPath build/IPA -exportOptionsPlist "$EXPORT_OPTIONS_PLIST"
                '''
            }
        }

        stage('Archive IPA') {
            steps {
                archiveArtifacts artifacts: 'build/IPA/*.ipa', fingerprint: true
            }
        }
    }
}
