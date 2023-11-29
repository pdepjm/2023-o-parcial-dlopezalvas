class Plato {
	
	method peso() 
	method aptoCeliacos() 
	method valoracion()
	
	method esEspecial() = self.peso() > 250

	method precio() = self.valoracion() * 300 + self.agregadoCeliaquia()

	method agregadoCeliaquia() = if(self.aptoCeliacos()) 1200 else 0

}


class Provoleta inherits Plato {
	
	const tieneEmpanado
	
	override method aptoCeliacos() = !tieneEmpanado
	
	override method esEspecial() = super() && tieneEmpanado
	
	override method valoracion() = if(self.esEspecial()) 120 else 80
}


class HamburguesaDeCarne inherits Plato {
	
	const pesoMedallon
	const pan
	
	override method peso() = self.pesoCarne() + pan.peso()
	
	method pesoCarne() = pesoMedallon
	
	override method aptoCeliacos() = pan.aptoCeliacos()
	
	override method valoracion() = self.peso() / 10
	
}

class HamburguesaDoble inherits HamburguesaDeCarne {
	override method pesoCarne() = pesoMedallon * 2
	override method esEspecial() = self.peso() > 500
}

object panIndustrial{
	method peso() = 60
	method aptoCeliacos() = false
}

object panCasero{
	method peso() = 100
	method aptoCeliacos() = false
}

object panMaiz {
	method peso() = 30
	method aptoCeliacos() = true
}


class CorteDeCarne inherits Plato{
	
	var peso
	var estaAPunto
	
	override method peso() = peso
	
	override method esEspecial() = super() && estaAPunto

	override method aptoCeliacos() = true
	
	override method valoracion() = 100
}


class Parrillada inherits Plato {
	const componentes = []
	
	override method peso() = componentes.sum({componente => componente.peso()})
	
	override method esEspecial() = super() && self.muchosComponentes()
	
	method muchosComponentes() = componentes.size() >= 3

	override method aptoCeliacos() = componentes.all({componente => componente.aptoCeliacos()})

	override method valoracion() = componentes.sum({componente => componente.valoracion()})
}

object parrillaMiguelito{
	const platos = []
	var ingresos = 0
	const comensales = []
	
	method platosAccesiblesCon(dinero) = platos.filter({plato => plato.precio() <= dinero})

	method vender(plato, comensal){
		ingresos += plato.precio()
		comensales.add(comensal)
	}
	
	method hacerPromocion(dineroADar){
		comensales.forEach({comensal => comensal.recibirDinero(dineroADar)})
	}
	
	method agregarPlatoAlMenu(plato){
		platos.add(plato)
	}
	
}

class Comensal {
	var dinero
	var preferencia
	
	method darseUnGusto(){
		if(self.platosQuePuedeComprar().size() == 0){
			throw new DomainException(message="No hay platos que puedan ser comprados")
		}
		self.comprarPlato(self.platoDeMayorValoracion())
	}
	
	method comprarPlato(plato){
		dinero -= plato.precio()
		parrillaMiguelito.vender(plato, self)
	}
	
	method platosQuePuedeComprar() = 
		parrillaMiguelito.platosAccesiblesCon(dinero).filter({plato => preferencia.leGusta(plato)})

	method platoDeMayorValoracion() = self.platosQuePuedeComprar().max{plato => plato.valoracion()}

	method recibirDinero(cantidad){
		dinero += cantidad
	}
	
	method cambiarHabito(nuevoHabito){
		preferencia = nuevoHabito
	}
	
	method tenerProblemasGastricos(){
		self.cambiarHabito(celiaco)
	}
	
	method puedeCambiarATodoTerreno() = preferencia.puedeCambiarATodoTerreno()
	
	//usado para test
	method dinero() = dinero
}

object celiaco {
	method leGusta(plato) = plato.aptoCeliacos()
	
	method puedeCambiarATodoTerreno() = false
}

object paladarFino {
	method leGusta(plato) = plato.esEspecial() || plato.valoracion() > 100
	method puedeCambiarATodoTerreno() = true
}

object todoTerreno{
	method leGusta(plato) = true
	method puedeCambiarATodoTerreno() = true
}

object gobierno {
	
	const ciudadanos = []
	
	method tomarDecisionEconomica() {
		self.ciudadanosAptosAlCambio().cambiarHabito(todoTerreno)
	}
	
	method ciudadanosAptosAlCambio() = ciudadanos.filter({ciudadano => ciudadano.puedeCambiarATodoTerreno()})
	
}