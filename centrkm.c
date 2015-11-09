/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 30/10 2015
Author  : 
Company : 
Comments: 


Chip type               : ATmega328P
Program type            : Application
AVR Core Clock frequency: 16,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*******************************************************/

#include <mega328p.h>
//#include <delay.h>

// Alphanumeric LCD functions
#include <alcd.h>

#define vyh_plus PORTD.4
#define vyh_minus PORTD.2
#define zvuk PORTD.5
#define vyh_t0 DDRD.6
#define kn1 PINC.0
#define shim OCR2B



// Declare your global variables here



// Declare your global variables here   \

// таблице синуса для формирования синусоидального напряжения
flash unsigned char sinus[] = {130,133,136,139,143,146,149,152,155,158,161,164,167,170,173,176,178,
181,184,187,190,192,195,198,200,203,205,208,210,212,215,217,219,221,223,225,227,229,231,233,234,236,
238,239,240,242,243,244,245,247,248,249,249,250,251,252,252,253,253,253,254,254,254,254,254,254,254,
253,253,253,252,252,251,250,249,249,248,247,245,244,243,242,240,239,238,236,234,233,231,229,227,225,
223,221,219,217,215,212,210,208,205,203,200,198,195,192,190,187,184,181,178,176,173,170,167,164,161,
158,155,152,149,146,143,139,136,133,130,127,124,121,118,115,111,108,105,102,99,96,93,90,87,84,81,78,
76,73,70,67,64,62,59,56,54,51,49,46,44,42,39,37,35,33,31,29,27,25,23,21,20,18,16,15,14,12,11,10,9,7,
6,5,5,4,3,2,2,1,1,1,0,0,0,0,0,0,0,1,1,1,2,2,3,4,5,5,6,7,9,10,11,12,14,15,16,18,20,21,23,25,27,29,31,33,35,37,39,42,
44,46,49,51,54,56,59,62,64,67,70,73,76,78,81,84,87,90,93,96,99,102,105,108,111,115,118,121,124,127};

unsigned int ton1,a;
unsigned char z, n, s435, period, per_old, per_new, i, sig_bayt, sig_bit, sost[32];
unsigned long time;
bit flag435, trevoga, pit_ok, sinc_err, pit_err, fix, nagh;

eeprom long procfreq = 16000000;
eeprom unsigned char esost[32] ;


// Standard Input/Output functions
#include <stdio.h>
                                 
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here
a = a + ton1;      // Формирование синусоиды (форма в массиве sinus)
z = a>>8 ;
OCR0B=sinus[z];

}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Place your code here
    time = time + 1;    // для измерения задержек (единица = 4 мС)
}

// Analog Comparator interrupt service routine
interrupt [ANA_COMP] void ana_comp_isr(void)
{
// Place your code here
per_old = per_new;
per_new = TCNT1L;
per_new = TCNT1H;
if(per_old < per_new) period = per_new - per_old; else period = per_new + (255 - per_old);  
    if ((period > 0x80)&&(period < 0xA0)) //если период соответствует частоте 435 Гц
    {
       if (s435++ > 4) flag435 = 1 ;  // обработка при обнаружени частоты 435
    } 
    else s435 = 0;
}

// TWI functions
#include <twi.h>

// TWI Slave receive buffer
#define TWI_RX_BUFFER_SIZE 32
unsigned char twi_rx_buffer[TWI_RX_BUFFER_SIZE];

// TWI Slave transmit buffer
#define TWI_TX_BUFFER_SIZE 32
unsigned char twi_tx_buffer[TWI_TX_BUFFER_SIZE];

// TWI Slave receive handler
// This handler is called everytime a byte
// is received by the TWI slave
bool twi_rx_handler(bool rx_complete)
{
if (twi_result==TWI_RES_OK)
   {
   // A data byte was received without error
   // and it was stored at twi_rx_buffer[twi_rx_index]
   // Place your code here to process the received byte
   // Note: processing must be VERY FAST, otherwise
   // it is better to process the received data when
   // all communication with the master has finished

   }
else
   {
   // Receive error
   // Place your code here to process the error

   return false; // Stop further reception
   }

// The TWI master has finished transmitting data?
if (rx_complete) return false; // Yes, no more bytes to receive

// Signal to the TWI master that the TWI slave
// is ready to accept more data, as long as
// there is enough space in the receive buffer
return (twi_rx_index<sizeof(twi_rx_buffer));
}

// TWI Slave transmission handler
// This handler is called for the first time when the
// transmission from the TWI slave to the master
// is about to begin, returning the number of bytes
// that need to be transmitted
// The second time the handler is called when the
// transmission has finished
// In this case it must return 0
unsigned char twi_tx_handler(bool tx_complete)
{
if (tx_complete==false)
   {
   // Transmission from slave to master is about to start
   // Return the number of bytes to transmit
   return sizeof(twi_tx_buffer);
   }

// Transmission from slave to master has finished
// Place code here to eventually process data from
// the twi_rx_buffer, if it wasn't yet processed
// in the twi_rx_handler

// No more bytes to send in this transaction
return 0;
}



 
unsigned int fdel(int freq)
{
    long koeff;              //определение коеффициента деления для получения частоты
    int delit;
    koeff = (16777216000/procfreq);
    koeff = (long)(koeff * freq);
    delit = koeff / 1000;
    return delit;
}

void clear_lcd(void)
{
    lcd_gotoxy(0,0);
    lcd_putsf("                                                                ");

}


void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=(1<<CLKPCE);
CLKPR=(0<<CLKPCE) | (0<<CLKPS3) | (0<<CLKPS2) | (0<<CLKPS1) | (0<<CLKPS0);
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Function: Bit7=In Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRB=(0<<DDB7) | (0<<DDB6) | (0<<DDB5) | (0<<DDB4) | (0<<DDB3) | (0<<DDB2) | (0<<DDB1) | (0<<DDB0);
// State: Bit7=T Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=T 
PORTB=(0<<PORTB7) | (0<<PORTB6) | (0<<PORTB5) | (0<<PORTB4) | (0<<PORTB3) | (0<<PORTB2) | (0<<PORTB1) | (0<<PORTB0);

// Port C initialization
// Function: Bit6=In Bit5=In Bit4=In Bit3=In Bit2=In Bit1=In Bit0=In 
DDRC=(0<<DDC6) | (0<<DDC5) | (0<<DDC4) | (0<<DDC3) | (0<<DDC2) | (0<<DDC1) | (0<<DDC0);
// State: Bit6=T Bit5=T Bit4=T Bit3=T Bit2=T Bit1=T Bit0=P
PORTC=(0<<PORTC6) | (0<<PORTC5) | (0<<PORTC4) | (0<<PORTC3) | (0<<PORTC2) | (0<<PORTC1) | (1<<PORTC0);

// Port D initialization
// Function: Bit7=In Bit6=In Bit5=Out Bit4=Out Bit3=Out Bit2=Out Bit1=In Bit0=In 
DDRD=(0<<DDD7) | (0<<DDD6) | (1<<DDD5) | (1<<DDD4) | (1<<DDD3) | (1<<DDD2) | (0<<DDD1) | (0<<DDD0);
// State: Bit7=P Bit6=T Bit5=0 Bit4=0 Bit3=0 Bit2=T Bit1=T Bit0=T 
PORTD=(1<<PORTD7) | (0<<PORTD6) | (0<<PORTD5) | (0<<PORTD4) | (0<<PORTD3) | (0<<PORTD2) | (0<<PORTD1) | (0<<PORTD0);

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 16000,000 kHz
// Mode: Fast PWM top=0xFF
// OC0A output: Non-Inverted PWM
// OC0B output: Disconnected
// Timer Period: 0,016 ms
// Output Pulse(s):
// OC0A Period: 0,016 ms Width: 0 us
TCCR0A=(1<<COM0A1) | (0<<COM0A0) | (0<<COM0B1) | (0<<COM0B0) | (1<<WGM01) | (1<<WGM00);
TCCR0B=(0<<WGM02) | (0<<CS02) | (0<<CS01) | (1<<CS00);
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;


// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 16000,000 kHz
// Mode: Normal top=0xFFFF
// OC1A output: Disconnected
// OC1B output: Disconnected
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer Period: 4,096 ms
// Timer1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=(0<<COM1A1) | (0<<COM1A0) | (0<<COM1B1) | (0<<COM1B0) | (0<<WGM11) | (0<<WGM10);
TCCR1B=(0<<ICNC1) | (0<<ICES1) | (0<<WGM13) | (0<<WGM12) | (0<<CS12) | (0<<CS11) | (1<<CS10);
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 16000,000 kHz
// Mode: Fast PWM top=0xFF
// OC2A output: Disconnected
// OC2B output: Non-Inverted PWM
// Timer Period: 0,016 ms
// Output Pulse(s):
// OC2B Period: 0,016 ms Width: 8,0314 us
ASSR=(0<<EXCLK) | (0<<AS2);
TCCR2A=(0<<COM2A1) | (0<<COM2A0) | (1<<COM2B1) | (0<<COM2B0) | (1<<WGM21) | (1<<WGM20);
TCCR2B=(0<<WGM22) | (0<<CS22) | (0<<CS21) | (1<<CS20);
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x80;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=(0<<OCIE0B) | (0<<OCIE0A) | (1<<TOIE0);

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=(0<<ICIE1) | (0<<OCIE1B) | (0<<OCIE1A) | (1<<TOIE1);

// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=(0<<OCIE2B) | (0<<OCIE2A) | (0<<TOIE2);

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: Off
EICRA=(0<<ISC11) | (0<<ISC10) | (0<<ISC01) | (0<<ISC00);
EIMSK=(0<<INT1) | (0<<INT0);
PCICR=(0<<PCIE2) | (0<<PCIE1) | (0<<PCIE0);

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART0 Mode: Asynchronous
// USART Baud Rate: 9600
UCSR0A=(0<<RXC0) | (0<<TXC0) | (0<<UDRE0) | (0<<FE0) | (0<<DOR0) | (0<<UPE0) | (0<<U2X0) | (0<<MPCM0);
UCSR0B=(0<<RXCIE0) | (0<<TXCIE0) | (0<<UDRIE0) | (1<<RXEN0) | (1<<TXEN0) | (0<<UCSZ02) | (0<<RXB80) | (0<<TXB80);
UCSR0C=(0<<UMSEL01) | (0<<UMSEL00) | (0<<UPM01) | (0<<UPM00) | (0<<USBS0) | (1<<UCSZ01) | (1<<UCSZ00) | (0<<UCPOL0);
UBRR0H=0x00;
UBRR0L=0x67;

// Analog Comparator initialization
// Analog Comparator: On
// The Analog Comparator's positive input is
// connected to the AIN0 pin
// The Analog Comparator's negative input is
// connected to the AIN1 pin
// Interrupt on Rising Output Edge
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=(0<<ACD) | (0<<ACBG) | (0<<ACO) | (0<<ACI) | (1<<ACIE) | (0<<ACIC) | (1<<ACIS1) | (1<<ACIS0);
ADCSRB=(0<<ACME);
// Digital input buffer on AIN0: On
// Digital input buffer on AIN1: On
DIDR1=(0<<AIN0D) | (0<<AIN1D);

// ADC initialization
// ADC disabled
ADCSRA=(0<<ADEN) | (0<<ADSC) | (0<<ADATE) | (0<<ADIF) | (0<<ADIE) | (0<<ADPS2) | (0<<ADPS1) | (0<<ADPS0);

// SPI initialization
// SPI disabled
SPCR=(0<<SPIE) | (0<<SPE) | (0<<DORD) | (0<<MSTR) | (0<<CPOL) | (0<<CPHA) | (0<<SPR1) | (0<<SPR0);

// TWI initialization
// Mode: TWI Slave
// Match Any Slave Address: Off
// I2C Bus Slave Address: 0x21
twi_slave_init(false,0x21,twi_rx_buffer,sizeof(twi_rx_buffer),twi_tx_buffer,twi_rx_handler,twi_tx_handler);

// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTB Bit 0
// RD - PORTB Bit 7
// EN - PORTB Bit 1
// D4 - PORTB Bit 2
// D5 - PORTB Bit 3
// D6 - PORTB Bit 4
// D7 - PORTB Bit 5
// Characters/line: 16
lcd_init(16);
lcd_putsf("  WELCOME!   ");
// Global enable interrupts

ACSR |= (1<<ACIE); // включить перывания от компарат
ACSR &= ~(1<<ACIE); // выкл прер компар

vyh_t0 = 0;             // выкл таймер 0
TCCR0B &= ~(1<<CS00); 



procfreq = 16000000 ;
ton1 = fdel(1080);

for (n = 0; n < 32; n++) esost[n] = 7; 

for (n = 0; n < 32; n++) sost[n] = esost[n]; 
//PORTD.4 = 1;
//delay_ms(100);
//PORTD.4 = 0;
//PORTD.2 = 1;
#asm("sei")
OCR2B=0x00; // выключение преобразователя

for(n=0;n<31;n++) sost[n] = esost[n]; // загрузка состояния с флеша.

    while (1)
    {   
      for (i = 0 ; i < 128 ; i++)
      {     
          if(kn1) nagh = 0;  // сброс флага нажатия при отпущеной кнопке      
          if(!kn1) 
          {
            if(!nagh)  // если кнопка только-что нажата 
            {            
                nagh = 1;
                lcd_gotoxy(3,0);
                if (fix)
                {
                    fix  = 0;         // если была включена фиксация, - выключить            
                    lcd_putchar(' ');
                }
                else
                {
                    fix = 1;         // включить фиксацию
                    lcd_putchar('F');  
                }

            }               
            
          }      
          sig_bayt = i / 4;    // текущий байт в слове состояния                 
          sig_bit = (i - sig_bayt * 4) * 2;   // текущая двухбитовая пара в слове состояния
          TCCR0B |= (1<<CS00);  // включить таймер 0;
          vyh_t0 = 1;  // переключить на выход 
          time = 0;
          while (time < 6);  // задержка 25 мСек
          zvuk = 0;  
          if(i == 0) while (time < 75); // если первый шаг, задержка 300 мСек
          OCR0B=127;
          vyh_t0 = 0;            // переключить а вход 
          TCCR0B &= ~(1<<CS00);    // выкл таймер 0              
          ACSR |= (1<<ACIE); // включить перывания от компарат   
          time = 0;
          while (time < 6);    // 25мСек
          ACSR &= ~(1<<ACIE); // выкл прер компар  
          if (flag435) // если был отлет 435 Гц
          { 
            switch (i)
            {
                case 31:  
                    // вывод первой половины на дисп  
                    if (!fix)
                    {
                        clear_lcd();
                        lcd_gotoxy(0,0);
                        lcd_putsf("1   ");
                        n = 1;
                        for (sig_bayt = 0; sig_bayt < 8 ; sig_bayt++)
                        {
                            for(sig_bit = 0; (sig_bayt == 3 || sig_bayt == 7)? sig_bit < 6: sig_bit < 8; sig_bit += 2)
                            {     
                                if(++n>10) n = 1;
                                lcd_putchar(47+n);
                                if((sost[sig_bayt]&(1<<sig_bit)))
                                {
                                     if((sost[sig_bayt]&(1<<(sig_bit+1)))) lcd_putchar(255); 
                                     else  lcd_putchar('.'); 
                                } else lcd_putchar(' ');
                            }
                        }  
                    } else 
                    {   
                       lcd_gotoxy(3,0);                         
                        if(!kn1)  
                        {
                            fix = 0;
                            lcd_putchar(' ');
                        }                                           
                        else lcd_putchar('F');
                           
                    }
                    pit_ok = 1;
                    break;
                case 15:
                case 47: 
                case 63: 
                case 79: 
                case 95: 
                case 111: 
                case 127:
                    sinc_err = 1;      // ошибка синхронизации
                    zvuk = 1;
                    break;
                default:
                    if (sost[sig_bayt]&(1<<sig_bit))
                    {    
                        while(time < 12); // 
                        flag435 = 0;
                        while(time < 18);                                                                // если объекм был по охраной тревога
                        if (flag435) 
                        {
                            sost[sig_bayt] |= (1<<(sig_bit+1));
                            trevoga = 1;  
                            zvuk = 1;
                        }
                        else   // если обект под охраной и короткий звук, нужно поставить под охрану.
                        {
                            OCR2B=0x80; // выдача на шим
                            vyh_plus = 1;
                        }
                            while(time<375)  
                            vyh_plus = 0;
                            OCR2B=0x00;
                    } 

            } 
          } 
          else      // если не было ответа
          { 
            switch (i)
            {
                case 31:  
                    if (!fix)
                    {
                        clear_lcd(); 
                        lcd_gotoxy(0,1);
                        lcd_putsf("Error Pitanie!!!");
                    } 

                    pit_err = 1;
                    pit_ok = 0;
                    break;   
                case 63:  
                    // вывод второй половины на дисп  
                    if (!fix)
                    {
                        clear_lcd();
                        lcd_gotoxy(0,0);
                        lcd_putsf("31  ");
                        n = 1;
                        for (sig_bayt = 8; sig_bayt < 16 ; sig_bayt++)
                        {
                            for(sig_bit = 0; (sig_bayt == 11 || sig_bayt == 15)? sig_bit < 6: sig_bit < 8; sig_bit += 2)
                            {     
                                if(++n>10) n = 1;
                                lcd_putchar(47+n);
                                if((sost[sig_bayt]&(1<<sig_bit)))
                                {
                                     if((sost[sig_bayt]&(1<<(sig_bit+1)))) lcd_putchar(255); 
                                     else  lcd_putchar('.'); 
                                } else lcd_putchar(' ');
                            }
                        }  
                    } 
                    
                    break;
                case 95: 
                    // вывод третьей половины на дисп  
                    if (!fix)
                    {
                        clear_lcd();
                        lcd_gotoxy(0,0);
                        lcd_putsf("61  ");
                        n = 1;
                        for (sig_bayt = 16; sig_bayt < 24 ; sig_bayt++)
                        {
                            for(sig_bit = 0; (sig_bayt == 19 || sig_bayt == 23)? sig_bit < 6: sig_bit < 8; sig_bit += 2)
                            {     
                                if(++n>10) n = 1;
                                lcd_putchar(47+n);
                                if((sost[sig_bayt]&(1<<sig_bit)))
                                {
                                     if((sost[sig_bayt]&(1<<(sig_bit+1)))) lcd_putchar(255); 
                                     else  lcd_putchar('.'); 
                                } else lcd_putchar(' ');
                            }
                        }  
                    } 
                    break;
                case 127:  
                    // вывод четвертой половины на дисп  
                    if (!fix)
                    {
                        clear_lcd();
                        lcd_gotoxy(0,0);
                        lcd_putsf("91  ");
                        n = 1;
                        for (sig_bayt = 24; sig_bayt < 32; sig_bayt++)
                        {
                            for(sig_bit = 0; (sig_bayt == 27 || sig_bayt == 31)? sig_bit < 6: sig_bit < 8; sig_bit += 2)
                            {     
                                if(++n>10) n = 1;
                                lcd_putchar(47+n);
                                if((sost[sig_bayt]&(1<<sig_bit)))
                                {
                                     if((sost[sig_bayt]&(1<<(sig_bit+1)))) lcd_putchar(255); 
                                     else  lcd_putchar('.'); 
                                } else lcd_putchar(' ');
                            }
                        }  
                    } 
                    for(n=0;n<31;n++) if (sost[n] != esost[n]) esost[n] = sost[n]; // запись изменений в еепром
                    break;
                case 15: 
                case 47: 
                case 79: 
                case 111: 
                    break;
                default:
                    if ((sost[sig_bayt]&(1<<sig_bit)) == 0) zvuk = 1; // звук если нет ответа от номера не под охраной
            } 
             
          } 
          flag435 = 0;             
          if (pit_ok)
          { 
            while (time < 125);
            pit_ok = 0;       
          }               
          
//          if (trevoga) //while (time < 375);
//          trevoga = 0;         
          if (sinc_err)  
          {
            sinc_err = 0;  
            if (!fix)
            {
                clear_lcd();
                lcd_gotoxy(0,1);
                lcd_putsf("  Error Sync!!! ");
            } else 
            {
                lcd_gotoxy(3,0); 
                lcd_putchar('F');   
            }
            break;
          }          
      }  
      

    }
    
}

