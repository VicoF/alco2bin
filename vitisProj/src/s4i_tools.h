/*
 * s4i_tools.h
 *
 *  Created on: 21 f�vr. 2020
 *      Author: francoisferland & Victor
 */

#ifndef SRC_S4I_TOOLS_H_
#define SRC_S4I_TOOLS_H_
#define S4I_NUM_SWITCHES	4

float voltage_to_alcool(float voltage);
float get_flow();

void			s4i_init_hw();
int 			s4i_is_cmd_sws(char *buf);
unsigned int 	s4i_get_sws_state();
int 			s4i_is_cmd_ethylo(char *buf);

float AD1_GetSampleVoltage();
float AD1_GetSampleVoltage1();
float AD1_GetMaxAlcoolVoltage();
float get_moy();
void setEthyloEnabled(int enable);
int readEthyloEnabled();
void startReflexTest();
int is_reflex_finished();
int get_reflex_result();
int is_reflex_error();
char* get_reflex_status();
int is_ethylo_error();
char* get_ethylo_status();

#endif /* SRC_S4I_TOOLS_H_ */
