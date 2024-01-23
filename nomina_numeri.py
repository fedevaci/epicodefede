#STAMPA i numeri da 0 a 9999 in italiano
def nominaventi(numero):
    if(numero>100):
        numero=numero%100
        if(numero>20):
            numero=numero%10
    elif(numero>20):
        numero=numero%10
    nomi_venti=["","uno","due","tre","quattro","cinque","sei","sette","otto","nove","dieci","undici","dodici","tredici","quattordici","quindici","sedici","diciasette","diciotto","diciannove","venti",]
    return nomi_venti[numero]

def nominacento(numero):
    if(numero>=1000):
        numero=numero%1000
        if(numero>=100):
            numero=numero%100
    if(numero>=100):
        numero=numero%100
    nomi_decine=["","dieci","venti","trenta","quaranta","cinquanta","sessanta","settanta","ottanta","novanta"]
    r=numero%10
    x=numero-r
    dec=round(x/10)
    return nomi_decine[dec]

def nominamille(numero):
    if(numero>=1000):
        numero=numero%1000
    nomi_centinaia=["","cento","duecento","trecento","quattrocento","cinquecento","seicento","settecento","ottocento","novecento"]
    r=numero%100
    x=numero-r
    cent=round(x/100)
    return nomi_centinaia[cent]

def nominadiecimila(numero):
    nomi_migliaia=["","mille","duemila","tremila","quattromila","cinquemila","seimila","settemila","ottomila","novemila"]
    r=numero%1000
    x=numero-r
    mill=round(x/1000)
    return nomi_migliaia[mill]
   
try:   
    numero=int(input("Inserisci un numero intero e ti darò il suo nome in italiano: ")) 
    if numero<0 or numero>9999:
        print("Fuori campo massimo. Il numero è negativo oppure è maggiore di 9999")
    if(numero==0):
        print("zero")
    elif(numero<20):
        print(nominaventi(numero))
    elif(numero<100):
        print(nominacento(numero)+nominaventi(numero))
    elif(numero<1000):
        print(nominamille(numero)+nominacento(numero)+nominaventi(numero))
    elif(numero<10000):
        print(nominadiecimila(numero)+nominamille(numero)+nominacento(numero)+nominaventi(numero))

except ValueError:
    print("Non hai inserito un numero! Prova a reinserire")
