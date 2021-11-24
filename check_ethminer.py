#!/usr/bin/python3
# coding: utf-8

import socket
import sys
import json
import getopt
import requests

def trexSummary(command="summary", HOST="localhost", PORT=4067):
    data=requests.get('http://' + HOST + ':' + str(PORT) + '/summary') 
    status_detail = ""
    status_detail = status_detail + " Uptime=" + str(round(data.json()["uptime"]/3600, 2)) + "h,"
    status_detail = status_detail + " Hashrate=" + str(round(data.json()["hashrate_hour"]/1000000, 3)) + "MH/s,"
    status_detail = status_detail + " Pool=" + data.json()["active_pool"]["url"] + ","
    status_detail = status_detail + " GPUs=" + str(data.json()["gpu_total"])
    performance_data = ""
    performance_data = performance_data + " Hashrate=" + str(data.json()["hashrate_minute"]) + "H/s"
    performance_data = performance_data + " Accepted=" + str(data.json()["accepted_count"]) + "shares"
    performance_data = performance_data + " Rejected=" + str(data.json()["rejected_count"]) + "shares"
    performance_data = performance_data + " Solved=" + str(data.json()["solved_count"]) + "blocks"
    print("OK:", status_detail, "|", performance_data)
    return 0

def queryMiner(command="miner_ping", HOST="localhost", PORT=3333):
    command=json.dumps({ "id":0,
                         "jsonrpc":"2.0",
                         "method": command 
                       }) #\n'
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect((HOST, PORT))
        s.sendall(command.encode('utf8') + b'\n')
        s.shutdown(1)
        data=json.loads(s.recv(1024).decode('utf8').replace("'", '"'))['result'] 
        s.close()
    return data

def commandMiner(password, command, params=None, HOST="localhost", PORT=3333):
    authorize=json.dumps({ "id":0,
                           "jsonrpc":"2.0",
                           "method":"api_authorize", 
                           "params":{"psw": password }
                          }) #\n'
    if (params is None):
        command=json.dumps({ "id":0,
                             "jsonrpc":"2.0",
                             "method": command 
                           }) #\n'
    else:
        command=json.dumps({ "id":0,
                             "jsonrpc":"2.0",
                             "method": command, 
                             "params": params
                           }) #\n'
        print(command)
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.connect((HOST, PORT))
        s.sendall(authorize.encode('utf8') + b'\n')
        authorize=json.loads(s.recv(1024).decode('utf8').replace("'", '"'))
        if ("error" not in authorize):
            s.sendall(command.encode('utf8') + b'\n')
            s.shutdown(1)
            data=json.loads(s.recv(1024).decode('utf8').replace("'", '"'))
        else:
            s.shutdown(1)
            data = authorize
        s.close()

    return data

# "miner_setactiveconnection" 
#        '{"index": 0}'
#        '{"URI": ".*etc.*"}' 
#        An error result if the index is out of bounds or the request is not properly formatted
# "miner_addconnection" 
#        '{"uri": "stratum+tcp://<ethaddress>.<workername>@eu1.ethermine.org:4444"}' 
#        An error if the uri is not properly formatted 
#        An error if you try to mix stratum mode with getwork mode (which begins with http://)
# "miner_removeconnection" 
#        '{"index": 2}' 
#        An error if the index is out of bounds or if the index corresponds to the currently active connection
# "miner_setscramblerinfo" 
#        '{"noncescrambler": 16704043538687679721, "segmentwidth": 38}' 
#        '{"noncescrambler": "0x6f3ab2803cfeea12", "segmentwidth": 38}'
# "miner_pausegpu" 
#        '{"index": 0, "pause": true}'
# "miner_setverbosity" 
#        '{"verbosity": 9}'

def miner(password="", method="miner_ping", params=None, HOST="localhost", PORT=3333):
    result = None

    if (method == "trex_summary"):
        if PORT==3333:
            result = trexSummary("summary", HOST, 4067)
        else:
            result = trexSummary("summary", HOST, PORT)
        return result
    elif (method == "miner_ping") | \
       (method == "miner_getstatdetail") | \
       (method == "miner_getstat1") | \
       (method == "miner_getconnections") | \
       (method == "miner_getscramblerinfo") :
        result = queryMiner(method, PORT=PORT)
    elif (method == "miner_restart") | \
         (method == "miner_reboot"): 
        result = commandMiner(password, method, params, HOST, PORT)
    elif (method == "miner_setactiveconnection") | \
         (method == "miner_addconnection") | \
         (method == "miner_removeconnection") | \
         (method == "miner_setscramblerinfo") | \
         (method == "miner_pausegpu") | \
         (method == "miner_setverbosity"):
        if (params is None):
            print("UNKNOWN: Missing Parameters")
            return 3
        else:
            result = commandMiner(password, method, params, HOST, PORT)
    else:
        print("UNKNOWN: Unknown method")
        return 3
    
    if (method == "miner_ping"):
        print("OK:", result)
        return 0
    elif (method == "miner_getstatdetail"):
        connection=result["connection"]
        devices=result["devices"]
        host=result["host"]
        mining=result["mining"]
        monitors=result["monitors"]
        print("OK:", result)
        return 0
    elif (method == "miner_getstat1"):
        minerver=result[0]
        runtime=result[1]
        eth_hashrate=result[2].split(";")
        eth_hashrates=result[3].split(";")
        dcr_hashrate=result[4].split(";")
        dcr_hashrates=result[5].split(";")
        tempfans=result[6].split(";")
        pool=result[7]
        shares_switches=result[8].split(";")
        status_detail = ""
        status_detail = status_detail + " Runtime=" + runtime + "min,"
        status_detail = status_detail + " ETH=" + eth_hashrate[0] + "KH/s,"
        #status_detail = status_detail + " DCR=" + dcr_hashrate[0] + "KH/s,"
        status_detail = status_detail + " Pool="+ pool
        performance_data = ""
        performance_data = performance_data + " ETH=" + str(int(eth_hashrate[0])*1000) + "H/s"
        performance_data = performance_data + " ETH:submitted=" + eth_hashrate[1] + "shares"
        performance_data = performance_data + " ETH:rejected=" + eth_hashrate[2] + "shares" 
        for i in range(len(eth_hashrates)):
            performance_data = performance_data + " ETH:GPU" + str(i) + "=" + str(int(eth_hashrates[i])*1000) + "H/s"
        #performance_data = performance_data + " DCR=" + str(int(dcr_hashrate[0])*1000) + "H/s"
        #performance_data = performance_data + " DCR:submitted=" + dcr_hashrate[1] + "shares"
        #performance_data = performance_data + " DCR:rejected=" + dcr_hashrate[2] + "shares"  
        #for i in range(len(dcr_hashrates)):
        #    performance_data = performance_data +  "DCR:GPU" + str(i) + "=" + str(int(dcr_hashrates[i])*1000) + "H/s"
        for i in range(0,len(tempfans),2):
            performance_data = performance_data + " GPU" + str(int(i/2)) + ":Temp=" + tempfans[int(i/2)] + "Celsius"
            performance_data = performance_data + " GPU" + str(int(i/2)) + ":Fans=" + tempfans[int(i/2)+1] + "%"
        performance_data = performance_data + " ETH:invalid=" + shares_switches[0] + "shares"
        performance_data = performance_data + " ETH:pool=" + shares_switches[1] + "switches"
        performance_data = performance_data + " DCR:invalid=" + shares_switches[2] + "shares"
        performance_data = performance_data + " DCR:pool=" + shares_switches[3] + "switches"
        print("OK:", status_detail, "|", performance_data)
        return 0
    elif (method == "miner_getconnections"):
        print("OK:", result)
        return 0
    elif (method == "miner_getscramblerinfo"):
        device_count=result["device_count"]
        device_width=result["device_count"]
        start_nonce=result["device_count"]
        print("OK:", result)
        return 0
    elif (method == "miner_restart"):
        if "error" in result.keys():
            print("CRIT:", result["error"])# ["code"], ": ", result["error"]["message"])
            return 2
        else:
            if (result["result"]):
                print("OK: Miner restarted |", result["result"])
                return 0
            else:
                print("WARN: Miner cannot be restarted |", result["result"])
                return 1
    elif (method == "miner_reboot"):
        if "error" in result.keys():
            print("CRIT:", result["error"])# ["code"], ": ", result["error"]["message"])
            return 2
        else:
            if (result["result"]):
                print("OK: Miner Rebooting |", result["result"])
                return 0
            else:
                print("WARN: Miner cannot Reboot |", result["result"])
                return 1
    elif (method == "miner_setscramblerinfo"):
        if "error" in result.keys():
            print("CRIT:", result["error"])# ["code"], ": ", result["error"]["message"])
            return 2
        else:
            print("OK:", result["result"])
            return 0
    elif (method == "miner_pausegpu"):
        if "error" in result.keys():
            print("CRIT:", result["error"])# ["code"], ": ", result["error"]["message"])
            return 2
        else:
            if (result["result"]):
                print("WARN: GPU", params["index"], "Paused |", result["result"])
                return 1
            else:
                print("OK: GPU", params["index"], "Unpaused |", result["result"])
                return 0
    elif (method == "miner_setverbosity"):
        if "error" in result.keys():
            print("CRIT:", result["error"])# ["code"], ": ", result["error"]["message"])
            return 2
        else:
            if result["result"]:
                print("OK: Verbosity set to", params["verbosity"])
                return 0
            else:
                print("WARN: Verbosity cannot be set |", result["result"])
                return 1
    elif (method == "miner_setactiveconnection"):
         if "error" in result.keys():
            print("CRIT:", result["error"])# ["code"], ": ", result["error"]["message"])
            return 2
         else:
            if (result["result"]):
                print("OK: Active connection set to:", params)
                return 0
            else:
                print("WARN: Active connection cannot be set |", result["result"])
                return 1

def main(argv):
    password=""
    method="miner_ping"
    params=None
    HOST="localhost"
    PORT=3333

    try:
        opts, args = getopt.getopt(argv,"hH:P:p:m:a:",["help","host=","port=","password=","method=","attributes="])
    except getopt.GetoptError:
        print('check_ethminer.py -i <inputfile> -o <outputfile>')
        sys.exit(2)

    for opt, arg in opts:
        if opt in ('-h', "--help"):
            print('check_ethminer.py -p <password> -m <method> -a <method attributes> -H <HOSTNAME> -P <PORT>')
            sys.exit(0)
        elif opt in ("-p", "--password"):
            password = arg
        elif opt in ("-H", "--host"):
            HOST = arg
        elif opt in ("-P", "--port"):
            PORT = int(arg)
        elif opt in ("-m", "--method"):
            method = arg
        elif opt in ("-a", "--attributes"):
            params = arg
    sys.exit(miner(password, method, params, HOST, PORT))

if __name__ == "__main__":
   main(sys.argv[1:])
