@echo off
:: Vérifier si nous avons déjà des droits d'administrateur
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

:: Si l'erreur de droits d'administration est renvoyée, relancer en tant qu'administrateur
if %errorlevel% neq 0 (
    echo Vous n'avez pas les droits d'administration. Demande d'accès administrateur...
    runas /user:Administrator "%~dp0%0" %*
    exit /b
)

:: Emplacement du projet 
set SOURCE_DIR=D:\S5\Deployement\Deploy\Deploye


:: Emplacement du répertoire source des classes
set SOURCE_CLASSES_DIR=D:\S5\Deployement\Deploy\Deploye\Script\src\java

:: Emplacement du répertoire de destination des fichiers compilés
set DEST_DIR=classes

:: Créez le répertoire de destination s'il n'existe pas
mkdir %DEST_DIR% 2>nul


:: Utilisez la commande dir pour trouver tous les fichiers .java
:: et passez-les à la commande javac
for /r %SOURCE_DIR% %%i in (*.java) do (
    javac -d %DEST_DIR% "%%i"
)

:: dossier temporaire
set TEMP_DIR=%SOURCE_DIR%\Projet

mkdir %SOURCE_DIR%

xcopy /s /e %SOURCE_DIR%\Script\web  %TEMP_DIR%\

xcopy /s /e classes %TEMP_DIR%\WEB-INF\classes\

:: Nom du fichier .war généré
set WAR_FILE=myprojet.war

jar cf %WAR_FILE% -C %TEMP_DIR%  .

move /Y %WAR_FILE% "C:\Program Files\Apache\Tomcat\webapps\"

