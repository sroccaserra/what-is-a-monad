type Prix = Double
type Quantite = Integer
type Taux = Double

total :: Prix -> Quantite -> Prix
total prix quantite = prix * fromIntegral quantite

ttc :: Taux -> Prix -> Prix
ttc taux prixHT = prixHT * (1 + taux)

main:: IO ()
main = putStrLn "hello"
