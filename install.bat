@echo off
echo ============================================================
echo      Simulateur Place Boursiere - Installateur Windows
echo ============================================================
echo.

:: Vérifier Python
where python >nul 2>nul
if %errorlevel% neq 0 (
    echo [ERREUR] Python n'est pas installe ou n'est pas dans le PATH.
    echo Veuillez installer Python 3.10+ depuis https://www.python.org/
    pause
    exit /b 1
)

echo [1/3] Installation des dependances Python via requirements.txt...
python -m pip install -r requirements.txt
if %errorlevel% neq 0 (
    echo [ATTENTION] Erreur lors de l'installation avec 'python'. Tentative avec 'py -3'...
    py -3 -m pip install -r requirements.txt
)

echo.
echo [2/3] Tentative de compilation du moteur C++ (engine.cpp)...
g++ -shared -fPIC -o finance/engine.dll finance/engine.cpp 2>nul
if %errorlevel% equ 0 (
    echo [INFO] Compilation reussie : engine.dll cree avec succes !
) else (
    echo [INFO] Compilateur C++ g++ absent ou echec. Le mode de secours Python pur sera utilise de maniere transparente.
)

echo.
echo [3/3] Initialisation de la base de donnees (Bronze, Silver, Gold)...
python populate_db.py
if %errorlevel% neq 0 (
    py -3 populate_db.py
)

echo.
echo ============================================================
echo                   INSTALLATION TERMINEE
echo ============================================================
echo Pour lancer le site internet localement, executez :
echo   streamlit run website/web.py
echo.
pause
