# SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
                                 
                                                  
                    

                                                 
                         
                          
                                                                                                 

                 

                                                              
                                    

                                                                       
 
                                                  

                                                                                                
                                                                                                
                                     

                                         

                                                                                           
                                                                                           
                                                                                            
                                    
                                                                                           


import csv
import os
import re

WALLY = os.environ.get("WALLY")

                                                
coremark_dir = os.path.join(WALLY, "benchmarks/coremark")
os.chdir(coremark_dir)


                               
arch_list = [
    "rv32i_zicsr",
    "rv32im_zicsr",
    "rv32imc_zicsr",
    "rv32im_zicsr_zba_zbb_zbs",
    "rv32gc",
    "rv32gc_zba_zbb_zbs",
    "rv64i_zicsr",
    "rv64im_zicsr",
    "rv64imc_zicsr",
    "rv64im_zicsr_zba_zbb_zbs",
    "rv64gc",
    "rv64gc_zba_zbb_zbs"
]

                                                        
mt_regex = r"Elapsed MTIME: (\d+).*?Elapsed MINSTRET: (\d+).*?COREMARK/MHz Score: [\d,]+ / [\d,]+ = (\d+\.\d+).*?CPI: \d+ / \d+ = (\d+\.\d+).*?Load Stalls (\d+).*?Store Stalls (\d+).*?D-Cache Accesses (\d+).*?D-Cache Misses (\d+).*?I-Cache Accesses (\d+).*?I-Cache Misses (\d+).*?Branches (\d+).*?Branches Miss Predictions (\d+).*?BTB Misses (\d+).*?Jump and JR (\d+).*?RAS Wrong (\d+).*?Returns (\d+).*?BP Class Wrong (\d+)"
                                           
                                                                 
                                      
resultfile = os.path.join(coremark_dir, 'coremark_results.csv')
                                     
with open(resultfile, mode='w', newline='') as csvfile:
    fieldnames = ['Architecture', 'CM / MHz','CPI','MTIME','MINSTRET','Load Stalls','Store Stalls','D$ Accesses',
                    'D$ Misses','I$ Accesses','I$ Misses','Branches','Branch Mispredicts','BTB Misses',
                    'Jump/JR','RAS Wrong','Returns','BP Class Pred Wrong']
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)

    writer.writeheader()

                                                              
    for arch in arch_list:
        xlen_value = "32" if "32" in arch else "64"
        os.system("make clean")
        make_all = f"make all XLEN={xlen_value} ARCH={arch}"
        os.system(make_all)

        make_run = f"make run XLEN={xlen_value} ARCH={arch}"
        print("Running: " + make_run)
        output = os.popen(make_run).read()                                     

                                                               
        mt_match = re.search(mt_regex, output,re.DOTALL)
                                                          
                                                            
                                                          

                                                                     

        mtime = mt_match.group(1)
        minstret= mt_match.group(2)
        cmhz= mt_match.group(3)
        cpi= mt_match.group(4)
        lstalls= mt_match.group(5)
        swtalls= mt_match.group(6)
        dacc= mt_match.group(7)
        dmiss= mt_match.group(8)
        iacc= mt_match.group(9)
        imiss= mt_match.group(10)
        br= mt_match.group(11)
        brm= mt_match.group(12)
        btb= mt_match.group(13)
        jmp= mt_match.group(14)
        ras= mt_match.group(15)
        ret= mt_match.group(16)
        bpc= mt_match.group(17)
                                             
        writer.writerow({'Architecture': arch, 'CM / MHz':cmhz,'CPI':cpi, 'MTIME': mtime,'MINSTRET':minstret,
                            'Load Stalls':lstalls,
                            'Store Stalls':swtalls,'D$ Accesses':dacc,'D$ Misses':dmiss,'I$ Accesses':iacc,'I$ Misses':imiss,
                            'Branches':br,'Branch Mispredicts':brm,'BTB Misses':btb,'Jump/JR':jmp,'RAS Wrong':ras,'Returns':ret,'BP Class Pred Wrong':bpc})
        csvfile.flush()
    csvfile.close()
