
class Mision{
	var peligrosidad
	var property habilidadesRequeridas=[]
	
	method serCumplica(asignado){
		self.validarHabilidades(asignado)
		asignado.recibirDanio(peligrosidad)
		asignado.finalizarMision(self)
	}	
	
	method validarHabilidades(asignado){
		if(not self.reuneHabilidadesRequeridas(asignado)){
			self.error("no se puede cumplir")
		}
	}
	method reuneHabilidadesRequeridas(asignado)=habilidadesRequeridas.all({habilidad=>asignado.puedeUsar(habilidad)})


	method enseniarHabilidades(empleado){
		self.habilidadesQueNoPosee(empleado).forEach({hab=>empleado.aprender(hab)})
	}
	
	method habilidadesQueNoPosee(empleado)=habilidadesRequeridas.filter({hab=> not empleado.poseeHabilidad(hab)})
}

class Equipo{
	var empleados=[]
	
	method puedeUsar(habilidad)=empleados.any({empleado=>empleado.puedeUsar(habilidad)})
	
	method recibirDanio(peligrosidad){
		empleados.forEach({empleado=>empleado.recibirDanio(peligrosidad/3)})
	}
	method finalizarMision(mision){
		empleados.forEach({empleado=>empleado.finalizarMision(mision)})
	}
}

class Empleado{
	const habilidades=[]
	var salud=100
	var puesto
	
	method aprender(habilidad){
		habilidades.add(habilidad)
	}
	
	method recibirDanio(peligrosidad){
		salud-=peligrosidad
	}
	method estaIncapacitado()=salud<self.saludCritica()
	
	method saludCritica()=puesto.saludCritica()
	
	method finalizarMision(mision){
		if(salud>0){
			self.completarMision(mision)
		}
	}
	
	method hacerseEspia(){
		puesto=puestoEspia
	}
	method completarMision(mision){
		puesto.completarMision(mision,self)
	}
	
	method puedeUsar(habilidad)=not self.estaIncapacitado() and self.poseeHabilidad(habilidad)
	
	method poseeHabilidad(habilidad)=habilidades.cointains(habilidad)
	
		
}




class Jefe inherits Empleado{
	var subordinados=[]
	
	override method poseeHabilidad(habilidad)=super(habilidad) or self.algunSubordinadoTiene(habilidad)
	
	method algunSubordinadoTiene(habilidad)=subordinados.any({subordinados => subordinados.puedeUsar(habilidad)})
} 


object puestoEspia{
	method saludCritica()=15
	method completarMision(mision,empleado){
		mision.enseniarHabilidades(empleado)
	}
}



class PuestoOficinista {
	
	var cantidadEstrellas=0
	
	method saludCritica()=40-5*cantidadEstrellas
	
	method sobreviveMision(){
		cantidadEstrellas+=1
	}
	
	method completarMision(mision,empleado){
		self.sobreviveMision()
		if(cantidadEstrellas>=3){
			empleado.hacerseEspia()
		}
	}
}
