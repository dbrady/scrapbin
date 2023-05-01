#!/bin/bash

echo -e "\033[36mTee writes to file and stdout. It makes a nice drop-in replacement for pipe.\033[0m"
echo -e ""
echo -e "\033[31mmyprogram >  program.log\033[0m  ---> \033[32mmyprogram | tee program.log\033[0m"
echo -e "\033[31mmyprogram >> program.log\033[0m  ---> \033[32mmyprogram | tee -a program.log\033[0m"
echo -e ""
echo -e "In theory, tee just lets you capture to a file while seeing the"
echo -e "capture on stdout. But it also does the reverse, letting you capture"
echo -e "logs at each step of a chain."
echo -e ""
echo -e "\033[31mmyprogram --csv \\"
echo -e "| cleanup-whitespace \\"
echo -e "| csv-to-json \\"
echo -e "| snow-calm-your-json > myprogram.json\033[0m"
echo -e "--->"
echo -e "\033[32mmyprogram --csv | tee myprogram.csv \\"
echo -e "| cleanup-whitespace | tee myprogram-clean.csv \\"
echo -e "| csv-to-json | tee myprogram-raw.json \\"
echo -e "| snow-calm-your-json | tee myprogram.json\033[0m"
