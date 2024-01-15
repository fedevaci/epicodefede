#1. Analisi delle Vendite Mensili:
        #◦ Domanda: Trova il totale delle vendite per ogni mese.
        
SELECT  YEAR(DataTransazione) AS Anno, MONTH(DataTransazione) AS Num, MONTHNAME(DataTransazione) AS Mese, CONCAT(CAST(SUM(ImportoTransazione) AS DECIMAL(10,2)), '   EURO') AS Totale
FROM transazioni
GROUP BY Anno, Num, Mese
ORDER BY Anno, Num;

#2. Prodotti più Venduti:
        #◦ Domanda: Identifica i tre prodotti più venduti e la loro quantità venduta.
        
SELECT p.ProdottoID AS Codice, p.NomeProdotto AS Prodotto, SUM(t.QuantitaAcquistata) AS Quantita
FROM prodotti p
JOIN transazioni t ON t.ProdottoID= p.ProdottoID
GROUP BY Codice
ORDER BY Quantita DESC
LIMIT 3;

#3. Analisi Cliente:
        #◦ Domanda: Trova il cliente che ha effettuato il maggior numero di acquisti

SELECT c.ClienteID AS Codice, c.NomeCliente AS Nominativo, COUNT(*) AS Acquisti
FROM clienti c
INNER JOIN transazioni t ON t.ClienteID= c.ClienteID
GROUP BY Codice
ORDER BY Acquisti DESC
LIMIT 10;

    #4. Valore medio della transazione:
        #◦ Domanda: Calcola il valore medio di ogni transazione sulla tipologia di spedizione.

SELECT MetodoSpedizione AS Spedizione, CONCAT(CAST(AVG(ImportoTransazione) AS DECIMAL(10,2)), ' EURO') AS ImportoMedio
FROM transazioni
GROUP BY Spedizione
ORDER BY ImportoMedio DESC;

    #5. Analisi Categoria Prodotto:
        #◦ Domanda: Determina la categoria di prodotto con il maggior numero di vendite.

SELECT p.Categoria AS Categoria, COUNT(*) AS Vendite
FROM prodotti p
INNER JOIN transazioni t ON t.ProdottoID= p.ProdottoID
GROUP BY Categoria
ORDER BY Vendite DESC
LIMIT 1;

    #6. Cliente Fedele:
        #◦ Domanda: Identifica il cliente con il maggior valore totale di acquisti. -> CLiente che ha speso di più
        
SELECT c.ClienteID AS Codice, c.NomeCliente AS Nome, SUM(t.ImportoTransazione) AS TotaleAcquisti
FROM clienti c
INNER JOIN transazioni t ON t.ClienteID= c.ClienteID
GROUP BY Codice
ORDER BY TotaleAcquisti DESC
LIMIT 1;


    #7. Spedizioni Riuscite:
        #◦ Domanda: Calcola la percentuale di spedizioni con "Consegna Riuscita".
SELECT CONCAT(CAST(((SELECT COUNT(*) FROM transazioni WHERE StatusConsegna='Consegna Riuscita')/COUNT(*))*100 AS DECIMAL(10,2)), '%')  AS Percentuale_Consegne_Riuscite
FROM transazioni;

#8. Prodotto con la Migliore Recensione:
		#◦ Domanda: Trova il prodotto con la recensione media più alta. --> dato che non è presente la colonna "recensioni", altero la tabella creando recensioni e randomicamente inserisco 500 valori interi compresi tra 1 e 5 stelle
/*ALTER TABLE transazioni ADD COLUMN(Recensione INT(3));

UPDATE transazioni
SET recensione = FLOOR(RAND() * 5) + 1
WHERE recensione IS NULL
LIMIT 500;*/

ALTER TABLE transazioni DROP COLUMN Recensione;

SELECT p.NomeProdotto as NOME, CONCAT(CAST(AVG(r.Rating) AS DECIMAL(2,1)),' STELLE') AS Valutazione
FROM transazioni t
INNER JOIN recensioni r ON t.ProdottoID=r.ProductID
INNER JOIN prodotti p ON p.ProdottoID=t.ProdottoID
GROUP BY p.ProdottoID
ORDER BY Valutazione DESC
LIMIT 100;
 #9. Analisi Temporale:
        #◦ Domanda: Calcola la variazione percentuale nelle vendite rispetto al mese precedente.
SELECT
  DATE_FORMAT(DataTransazione, '%Y-%m') AS Mese,
  CAST(SUM(ImportoTransazione) AS DECIMAL(10,2)) AS Totale,
  CAST(LAG(SUM(ImportoTransazione)) OVER (ORDER BY DATE_FORMAT(DataTransazione, '%Y-%m')) AS DECIMAL(10,2)) AS Precedente,
  CONCAT(CAST(((SUM(ImportoTransazione)/LAG(SUM(ImportoTransazione)) OVER (ORDER BY DATE_FORMAT(DataTransazione, '%Y-%m')))*100-100) AS DECIMAL(7,2)),'%') AS Incremento
FROM
  transazioni
GROUP BY Mese
ORDER BY Mese;

  #10. Quantità di Prodotti Disponibili:
	    #◦ Domanda: Determina la quantità media disponibile per categoria di prodotto. --> quindi calcolo la media delle quantità dei prodotti appartenenti a una medesima categoria
        
SELECT Categoria, CAST(AVG(QuantitaDisponibile)AS DECIMAL(10,2)) AS Disponibili
FROM prodotti
GROUP BY Categoria
ORDER BY Disponibili DESC;
        
  #11. Analisi Spedizioni:
        #◦ Domanda: Trova il metodo di spedizione più utilizzato. --> raggruppo per metodo e poi erogo il primo metodo per utilizzo con relativa percentuale di utilizzo
SELECT CONCAT('Il metodo di spedizione piu'' usato e'' ',MetodoSpedizione) AS Risultato,
		 CONCAT(CAST((COUNT(*)/(SELECT COUNT(*) FROM transazioni))*100 AS DECIMAL(10,2)), '%') AS Utilizzo
FROM transazioni 
GROUP BY MetodoSpedizione
ORDER BY Utilizzo DESC
LIMIT 1;
        
    #12. Analisi dei Clienti:
        #◦ Domanda: Calcola il numero medio di clienti registrati al mese. --> l'ho inteso semplicemente come il numero di registrati ogni mese, col rispettivo anno di riferimento
SELECT DATE_FORMAT(DataRegistrazione, '%Y-%m') AS Mese, COUNT(*) AS Registrazioni
FROM clienti 
GROUP BY Mese
ORDER BY Mese DESC;

    #13. Prodotti Rari:
        #◦ Domanda: Identifica i prodotti con una quantità disponibile inferiore alla media.
SELECT NomeProdotto, QuantitaDisponibile, (SELECT CAST(AVG(QuantitaDisponibile) AS DECIMAL(10,2)) FROM prodotti) AS Media
FROM prodotti
WHERE QuantitaDisponibile < (SELECT AVG(QuantitaDisponibile) FROM prodotti)
ORDER BY QuantitaDisponibile
LIMIT 10000;

    #14. Analisi dei Prodotti per Cliente:
        #◦ Domanda: Per ogni cliente, elenca i prodotti acquistati e il totale speso.
SELECT c.NomeCliente AS Cliente, COUNT(p.NomeProdotto) AS Prodotti, CONCAT(CAST(SUM(t.ImportoTransazione) AS DECIMAL(10,2)),'   EURO') AS Spesa_TOT
FROM transazioni t
INNER JOIN clienti c ON t.ClienteID=c.ClienteID
INNER JOIN prodotti p ON t.ProdottoID=p.ProdottoID
GROUP BY Cliente
ORDER BY Prodotti DESC;

    #15. Miglior Mese per le Vendite:
        #◦ Domanda: Identifica il mese con il maggior importo totale delle vendite.
SELECT CONCAT('Il mese con importo totale delle vendite maggiore e'' il ',DATE_FORMAT(DataTransazione, '%Y-%m')) AS Risultato, CONCAT(CAST(SUM(ImportoTransazione)AS DECIMAL(10,2)),'   EURO') AS Totale
FROM transazioni
GROUP BY DATE_FORMAT(DataTransazione, '%Y-%m')
ORDER BY Totale DESC
LIMIT 1;

    #16. Analisi dei Prodotti in Magazzino:
        #◦ Domanda: Trova la quantità totale di prodotti disponibili in magazzino. --> li ho divisi per categoria
SELECT Categoria, SUM(QuantitaDisponibile) AS Pezzi
FROM prodotti
GROUP BY Categoria;
   # 17. Clienti Senza Acquisti:
        #◦ Domanda: Identifica i clienti che non hanno effettuato alcun acquisto.
        #a.
SELECT COUNT(*) AS Inattivi
FROM clienti c
LEFT JOIN transazioni t ON c.ClienteID=t.ClienteID
WHERE t.ClienteID is NULL;
		#b. --> mi faccio restituire anche la data di iscrizione, per capire quanto tempo è rimasto inattivo e magari sollecitarlo con delle mail.
SELECT c.ClienteID as Cod, c.NomeCliente AS Nominativo, c.Email AS Email, DATE_FORMAT(c.DataRegistrazione, '%Y-%m-%d') AS Iscrizione
FROM clienti c
LEFT JOIN transazioni t ON c.ClienteID=t.ClienteID
WHERE t.ClienteID is NULL
ORDER BY Iscrizione ASC
LIMIT 5000;

	#18. Analisi Annuale delle Vendite:
        #◦ Domanda: Calcola il totale delle vendite per ogni anno.
SELECT YEAR(DataTransazione) AS Anno, CAST(SUM(ImportoTransazione) AS DECIMAL(10,2)),'  EURO') AS TOTALE_ANNO
FROM transazioni
GROUP BY Anno
ORDER BY Anno DESC;
   #19. Spedizioni in Ritardo:
        #◦ Domanda: Trova la percentuale di spedizioni con "In Consegna" rispetto al totale.
SELECT CONCAT('Le spedizioni in ritardo sono il ',CAST(((SELECT COUNT(*) FROM transazioni WHERE StatusConsegna='In Consegna')/COUNT(*))*100 AS DECIMAL(10,2)), '%') AS Risultato
FROM transazioni

        
/*DROP TABLE clienti;
DROP TABLE prodotti;
DROP TABLE transazioni;
DROP TABLE spedizioni;*/