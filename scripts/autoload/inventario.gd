extends Node
## Autoload "Inventario": guarda os itens que Maria carrega.
## Regras da bíblia: no máximo 5 itens e sem combinações.
## Cada item é identificado pela chave de tradução do seu nome (ex.: "ITEM_TESTE").

const LIMITE: int = 5

## Emitido sempre que um item entra ou sai.
signal mudou

var itens: Array[String] = []


func esta_cheio() -> bool:
	return itens.size() >= LIMITE


func tem(chave_item: String) -> bool:
	return chave_item in itens


## Retorna false se não couber; quem chamou decide o que fazer (ex.: avisar o jogador).
func adicionar(chave_item: String) -> bool:
	if esta_cheio():
		return false
	itens.append(chave_item)
	mudou.emit()
	return true


## Usado quando um item é gasto no lugar certo (ex.: pilhas na lanterna).
func remover(chave_item: String) -> bool:
	if not tem(chave_item):
		return false
	itens.erase(chave_item)
	mudou.emit()
	return true
