#include <nds.h>
#include <stdio.h>

int main() {
    consoleDemoInit();

    consoleClear();

    iprintf("\x1b[0;0H");

    iprintf("=====================\n");
    iprintf("      FORGE 0.1        \n");
    iprintf("=====================\n\n");

    iprintf("Hello, world!\n");
    iprintf("Forging the future\n");
    iprintf("on forgotten hardware.\n\n");

    iprintf("Press START to exit.\n");

    while (true) {
        swiWaitForVBlank();
        scanKeys();

        if (keysDown() & KEY_START) {
            break;
        }
    }

    consoleDemoInit();
    return 0;
}
