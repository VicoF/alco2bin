/*
 * s4i_tools.c
 *
 *  Created on: 21 fÃ©vr. 2020
 *      Author: francoisferland
 */

#include "s4i_tools.h"
#include "xparameters.h"
#include <stdio.h>
#include "xil_printf.h"
#include "sleep.h"
#include "PmodGPIO.h"
#include "PmodOLED.h"
#include <xgpio.h>
#include "my_ADCip.h"
#include <math.h>


#define MY_AD1_IP_BASEADDRESS  XPAR_MY_ADCIP_0_S00_AXI_BASEADDR
#define AD1_NUM_BITS 	12
const float ReferenceVoltage = 3.3;
XGpio s4i_xgpio_input_;

void s4i_init_hw()
{
    // Initialise laccï¿½s au matÅ½riel GPIO pour s4i_get_sws_state().
	XGpio_Initialize(&s4i_xgpio_input_, XPAR_AXI_GPIO_0_DEVICE_ID);
	XGpio_SetDataDirection(&s4i_xgpio_input_, 1, 0xF);
}

int s4i_is_cmd_sws(char *buf)
{
    // TODO: VÅ½rifier si la chaâ€�ne donnÅ½e correspond Ë† "cmd/sws".
    // Retourner 0 si ce nest pas le cas.
    // Attention: la chaâ€�ne possï¿½de la requï¿½te complï¿½te (ex. "GET /cmd/sws").
    // Un indice : Allez voir les mÅ½thodes similaires dans web_utils.c.

	/* skip past GET / */
		buf += 5;

		/* then check for cmd/sws */
		return (!strncmp(buf, "cmd", 3) && !strncmp(buf + 4, "sws", 3));
}

int s4i_is_cmd_ethylo(char *buf)
{
    // TODO: VÅ½rifier si la chaâ€�ne donnÅ½e correspond Ë† "cmd/ethylo".
    // Retourner 0 si ce nest pas le cas.

	/* skip past GET / */
		buf += 5;

		/* then check for cmd/ethylo */
		return (!strncmp(buf, "cmd", 3) && !strncmp(buf + 4, "ethylo", 6));
}


unsigned int s4i_get_sws_state()
{
    // Retourne lÅ½tat des 4 interrupteurs dans un entier (un bit par
    // interrupteur).
    return XGpio_DiscreteRead(&s4i_xgpio_input_, 1);
}

void hex_to_bin(unsigned int i, unsigned int tab[]) {
	        tab[3] = i & 1;
	        tab[2] = (i >> 1) & 1;
	        tab[1] = (i >> 2) & 1;
	        tab[0] = (i >> 3) & 1;
}

u16 AD1_GetSampleRaw()
{
	u16 rawData =  MY_ADCIP_mReadReg(MY_AD1_IP_BASEADDRESS, 0x0) & 0xFFF;
	return rawData;
}

u16 AD1_GetSampleRaw1()
{
	u16 rawData =  MY_ADCIP_mReadReg(MY_AD1_IP_BASEADDRESS, 0x4) & 0xFFF;
	return rawData;
}

void setEthyloEnabled(int enable)
{
	if(enable){
		xil_printf("Ethylo test started... collecting data\n");
		}else{
			xil_printf("Ethylo test stoped\n");
		}
	MY_ADCIP_mWriteReg(MY_AD1_IP_BASEADDRESS, 0x8, enable);

}

float AD1_GetSampleVoltage()
{
	float conversionFactor = ReferenceVoltage / ((1 << AD1_NUM_BITS) - 1);

	u16 rawSample = AD1_GetSampleRaw();

	return (float)rawSample * conversionFactor;

}

float AD1_GetSampleVoltage1()
{
	float conversionFactor = ReferenceVoltage / ((1 << AD1_NUM_BITS) - 1);

	u16 rawSample = AD1_GetSampleRaw1();

	return (float)rawSample * conversionFactor;

}

float voltage_to_alcool(float voltage)
{
	float ppm = expf((voltage+0.8659f)/0.6058);
	return ppm*0.000998859f;
}

float get_flow()
{
//return flow*1000/3.3;
	return (float) AD1_GetSampleRaw1();
}

