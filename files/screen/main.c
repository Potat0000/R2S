/*
 * main.c
 *
 *  Description : R2S Screen Control
 *  Author      : Gyj1109
 */

/* Lib Includes */
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>

/* Header Files */
#include "I2C.h"
#include "SSD1306_OLED.h"

#define BUFMAX SSD1306_LCDWIDTH*SSD1306_LCDHEIGHT

const float flush_time = 0.8;

static volatile sig_atomic_t keep_running = 1;
static void sig_handler(int _) {
    (void)_;
    keep_running = 0;
}

FILE *fp;
char content_buff[BUFMAX];
char buf[BUFMAX];
long long up_time1, up_time2, down_time1, down_time2;
double delta_up_time, delta_down_time;

int main() {
    if(init_i2c_dev(I2C_DEV0_PATH, SSD1306_OLED_ADDR) != 0) {
        printf("R2S Screen Control: OOPS! Something Went Wrong!\r\n");
        exit(1);
    }

    display_Init_seq();
    clearDisplay();

    setTextSize(1);
    setTextColor(WHITE);
    setTextWrap(false);

    signal(SIGINT, sig_handler);
    while (keep_running) {
        clearDisplay();
        setCursor(0,0);

        memset(content_buff, 0, BUFMAX);
        memset(buf, 0, BUFMAX);
        if((fp=popen("cat /sys/class/thermal/thermal_zone0/temp", "r")) != NULL) {
            fgets(content_buff, 5, fp);
            fclose(fp);
            sprintf(buf, "   Temp: %.2f C", atoi(content_buff) / 100.0);
            print_strln(buf);
            drawCircle(88, 1, 1, WHITE);
        }

        memset(content_buff, 0, BUFMAX);
        memset(buf, 0, BUFMAX);
        if((fp=popen("cat /sys/devices/system/cpu/cpu[04]/cpufreq/cpuinfo_cur_freq", "r")) != NULL) {
            fgets(content_buff, 8, fp);
            fclose(fp);
            sprintf(buf, "   Freq:  %4d MHz", atoi(content_buff) / 1000);
            print_strln(buf);
        }

        up_time1 = up_time2;
        down_time1 = down_time2;
        memset(content_buff, 0, BUFMAX);
        if((fp=popen("cat /sys/class/net/eth0/statistics/tx_bytes", "r")) != NULL) {
            fgets(content_buff, 8, fp);
            fclose(fp);
            up_time2 = atoi(content_buff);
        }
        memset(content_buff, 0, BUFMAX);
        if((fp=popen("cat /sys/class/net/eth0/statistics/rx_bytes", "r")) != NULL) {
            fgets(content_buff, 8, fp);
            fclose(fp);
            down_time2 = atoi(content_buff);
        }
        memset(buf, 0, BUFMAX);
        delta_up_time = (up_time2 - up_time1) / flush_time / 16;         // KB/s
        if ((up_time1 == 0) || (up_time2 == 0) || (delta_up_time >= 1024000) || (delta_up_time < 0)) {delta_up_time = 0;}
        if (delta_up_time >= 1000) {
            sprintf(buf, "    Up: %6.2f MB/s", delta_up_time / 1024);
        } else {
            sprintf(buf, "    Up: %6.2f KB/s", delta_up_time);
        }
        print_strln(buf);
        memset(buf, 0, BUFMAX);
        delta_down_time = (down_time2 - down_time1) / flush_time / 1.2;  // KB/s
        if ((down_time1 == 0) || (down_time2 == 0) || (delta_down_time >= 1024000) || (delta_down_time < 0)) {delta_down_time = 0;}
        if (delta_down_time >= 1000) {
            sprintf(buf, "   Down:%6.2f MB/s", delta_down_time / 1024);
        } else {
            sprintf(buf, "   Down:%6.2f KB/s", delta_down_time);
        }
        print_strln(buf);

        Display();
        usleep(flush_time * 1000000);
    }
    clearDisplay();
    setCursor(0,0);
    Display();
    printf("\n");
}
