// clang -g -O2 -std=c11 -Wall -framework ApplicationServices ./grayscale.c -o toggle-grayscale
// https://apple.stackexchange.com/a/342551/321957
// 1. Compile this to a binary executable
// 2. Create a "Quick action" in automator, naming it "Toggle Grayscale"
// 3. Create a global keyboard shortcut that triggers the "Toggle Grayscale" item form the Services menu
#include <stdio.h>
#include <ApplicationServices/ApplicationServices.h>

CG_EXTERN bool CGDisplayUsesForceToGray(void);
CG_EXTERN void CGDisplayForceToGray(bool forceToGray);

int
main(int argc, char** argv)
{
    bool isGrayscale = CGDisplayUsesForceToGray();
    // printf("isGrayscale = %d\n", isGrayscale);
    CGDisplayForceToGray(!isGrayscale);
    // printf("Grayscale is now: %d\n", CGDisplayUsesForceToGray());

    return 0;
}