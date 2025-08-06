function cheat
    if test (count $argv) -eq 0
        echo "Devi fornire un argomento. Esempio: cheat tar"
        return 1
    end

    if test "$argv[1]" = "-h"
        echo "Utilizzo: cheat <comando>"
        echo ""
        echo "Mostra un cheat sheet per il comando specificato, usando cheat.sh."
        echo "Esempio:"
        echo "  cheat tar"
        echo "  cheat git"
        return 0
    end

    curl cheat.sh/$argv | bat
end

