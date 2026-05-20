#!/bin/bash
echo "============================================================"
echo "      Simulateur Place Boursiere - Installateur Unix"
echo "============================================================"
echo ""

# Vérifier Python
if ! command -v python3 &> /dev/null
then
    echo "[ERREUR] Python 3 n'est pas installe ou n'est pas dans le PATH."
    exit 1
fi

echo "[1/3] Installation des dependances Python via requirements.txt..."
python3 -m pip install -r requirements.txt

echo ""
echo "[2/3] Tentative de compilation du moteur C++ (engine.cpp)..."
OS_NAME=$(uname -s)
if [ "$OS_NAME" = "Darwin" ]; then
    LIB_EXT="dylib"
else
    LIB_EXT="so"
fi

g++ -shared -fPIC -o finance/engine.${LIB_EXT} finance/engine.cpp 2>/dev/null
if [ $? -eq 0 ]; then
    echo "[INFO] Compilation reussie : finance/engine.${LIB_EXT} cree !"
else
    clang++ -shared -fPIC -o finance/engine.${LIB_EXT} finance/engine.cpp 2>/dev/null
    if [ $? -eq 0 ]; then
        echo "[INFO] Compilation reussie via clang++ : finance/engine.${LIB_EXT} cree !"
    else
        echo "[INFO] Compilateur C++ (g++/clang++) absent ou echec. Le mode de secours Python pur sera utilise."
    fi
fi

echo ""
echo "[3/3] Initialisation de la base de donnees..."
python3 populate_db.py

echo ""
echo "============================================================"
echo "                   INSTALLATION TERMINEE"
echo "============================================================"
echo "Pour lancer le site internet localement, executez :"
echo "   streamlit run website/web.py"
echo ""
