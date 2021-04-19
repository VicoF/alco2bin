#include "PmodOLED.h"
#include "s4i_tools.h"
PmodOLED myDevice;

void initialize_oled() {
	// EnableCaches();
	OLED_Begin(&myDevice, XPAR_PMODOLED_0_AXI_LITE_GPIO_BASEADDR,
	XPAR_PMODOLED_0_AXI_LITE_SPI_BASEADDR, 0, 0);
}
void DemoRun() {
	int irow, ib, i;
	u8 *pat;
	char c;

	xil_printf("UART and SPI opened for PmodOLED Demo\n\r");

	while (1) {
		xil_printf("entering loop\r\n");
		// Choosing Fill pattern 0
		pat = OLED_GetStdPattern(0);
		OLED_SetFillPattern(&myDevice, pat);
		// Turn automatic updating off
		OLED_SetCharUpdate(&myDevice, 0);

		// Draw a rectangle over writing then slide the rectangle down slowly
		// displaying all writing
		for (irow = 0; irow <= OledRowMax; irow++) {
			OLED_ClearBuffer(&myDevice);
			OLED_SetCursor(&myDevice, 0, 0);
			OLED_PutString(&myDevice, "PmodOLED");
			OLED_SetCursor(&myDevice, 0, 1);
			OLED_PutString(&myDevice, "by Digilent");
			OLED_SetCursor(&myDevice, 0, 2);
			OLED_PutString(&myDevice, "Simple Demo");

			OLED_MoveTo(&myDevice, 0, irow);
			OLED_FillRect(&myDevice, 127, 31);
			OLED_MoveTo(&myDevice, 0, irow);
			OLED_LineTo(&myDevice, 127, irow);
			OLED_Update(&myDevice);
			usleep(100000);
		}

		sleep(1);
		// Blink the display three times.
		for (i = 0; i <= 3; i++) {
			OLED_DisplayOff(&myDevice);
			usleep(500000);
			OLED_DisplayOn(&myDevice);
			usleep(500000);
		}
		sleep(2);

		// Now erase the characters from the display
		for (irow = OledRowMax - 1; irow >= 0; irow--) {
			OLED_SetDrawColor(&myDevice, 1);
			OLED_SetDrawMode(&myDevice, OledModeSet);
			OLED_MoveTo(&myDevice, 0, irow);
			OLED_LineTo(&myDevice, 127, irow);
			OLED_Update(&myDevice);
			usleep(25000);
			OLED_SetDrawMode(&myDevice, OledModeXor);
			OLED_MoveTo(&myDevice, 0, irow);
			OLED_LineTo(&myDevice, 127, irow);
			OLED_Update(&myDevice);
		}

		sleep(1);

		// Draw a rectangle in center of screen
		// Display the 8 different patterns available
		OLED_SetDrawMode(&myDevice, OledModeSet);

		for (ib = 1; ib <= 8; ib++) {
			OLED_ClearBuffer(&myDevice);
			pat = OLED_GetStdPattern(ib);
			OLED_SetFillPattern(&myDevice, pat);
			OLED_MoveTo(&myDevice, 55, 1);
			OLED_FillRect(&myDevice, 75, 27);
			OLED_DrawRect(&myDevice, 75, 27);
			OLED_Update(&myDevice);

			sleep(1);
		}

	}
	xil_printf("Exiting PmodOLED Demo\n\r");
}

void draw() {
	int irow, ib, i;
	u8 *pat;
	char c;

	OLED_SetDrawMode(&myDevice, OledModeSet);

	OLED_ClearBuffer(&myDevice);
	pat = OLED_GetStdPattern(1);
	OLED_SetFillPattern(&myDevice, pat);
	OLED_MoveTo(&myDevice, 0, 0);
	OLED_FillRect(&myDevice, 75, 27);
	OLED_DrawRect(&myDevice, 75, 27);
	OLED_Update(&myDevice);

	sleep(1);

}

void draw_ethylo_flow() {
	u8 *pat;

	float valeur = get_flow();
	OLED_SetDrawMode(&myDevice, OledModeSet);

	OLED_ClearBuffer(&myDevice);
	pat = OLED_GetStdPattern(1);
	OLED_SetFillPattern(&myDevice, pat);

	OLED_SetCursor(&myDevice, 8, 3);
	OLED_PutString(&myDevice, "|");

	OLED_SetCursor(&myDevice, 8, 2);
	OLED_PutString(&myDevice, "|");

	OLED_SetCursor(&myDevice, 8, 1);
	OLED_PutString(&myDevice, "|");
	//bar de droite
	OLED_SetCursor(&myDevice, 12, 3);
	OLED_PutString(&myDevice, "|");

	OLED_SetCursor(&myDevice, 12, 2);
	OLED_PutString(&myDevice, "|");

	OLED_SetCursor(&myDevice, 12, 1);
	OLED_PutString(&myDevice, "|");

	OLED_Update(&myDevice);
	OLED_MoveTo(&myDevice, 0, 0);
	// série de if pour les 10 états possibles
	int xcoord = (int) (valeur*128/1000);
	xil_printf("%u\n", xcoord);
	OLED_FillRect(&myDevice, xcoord, 32);
	OLED_DrawRect(&myDevice, xcoord, 32);
	OLED_Update(&myDevice);

}
int display_thread() {
	xil_printf("Allo les cocos");
	return 0;
}
