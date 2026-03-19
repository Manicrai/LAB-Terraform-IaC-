# 📚 Explicación del Laboratorio: Topología Hub & Spoke en Azure

Este documento detalla los conceptos fundamentales y los componentes técnicos creados a lo largo de este laboratorio práctico de Infraestructura como Código (IaC) con Terraform en Azure.

## 🎯 Objetivo General
Implementar un diseño de red empresarial escalable y seguro llamado **Central y Radio (Hub and Spoke)**, aislando por completo los entornos de "Desarrollo" y "Producción" pero manteniendo un punto único de administración centralizado ("Jumpbox").

## 🧩 Componentes del Laboratorio

### 1. El Hub (La Central)
Es la red principal que gobierna y enlaza todo. Creamos la VNet `vnet-hub` y dentro provisionamos dos subredes fundamentales:
- **`GatewaySubnet`:** Una subred con un nombre reservado y estricto por Azure, destinada a alojar un *VPN Gateway* o *ExpressRoute* en futuras iteraciones del proyecto para conectar oficinas físicas con la Nube.
- **`snet-shared-services`:** Subred genérica del Hub. Aquí albergamos nuestro **Jumpbox**.

### 2. El Jumpbox (Servidor Bastión)
Ubicado en el corazón del Hub (`snet-shared-services`), es una máquina virtual ligera (`Standard_B1s`) con sistema operativo Ubuntu, que cuenta con una **Dirección IP Pública**. Sirve como el "único punto de entrada autorizado" desde Internet a tu capa privada de la nube.
- Tiene asignado un **Grupo de Seguridad de Red (NSG)** que ejerce de firewall y protege el servidor, permitiendo estrictamente tráfico externo únicamente por el puerto `22` (SSH).

### 3. Los Spokes (Los Radios / Periferia)
Creamos dos Redes Virtuales completamente nuevas e independientes: `vnet-spoke-prod` y `vnet-spoke-dev`. Se trata de islas privadas diseñadas para hospedar las aplicaciones de negocio, impidiendo que convivan mezcladas en un mismo lugar.
- En su interior desplegamos pequeños servidores Linux que **carecen de IP Pública**, por lo que son totalmente invisibles para Internet. Su administración se gestiona exclusivamente usando su IP Privada.

### 4. VNet Peering (Emparejamiento de Redes)
Por defecto, las VNets de Azure están aisladas y no pueden comunicarse entre sí, ni por IPs privadas. Hemos configurado el enrutamiento construyendo **cuatro enlaces VNet Peering** bidireccionales:
- Hub <--> Producción
- Hub <--> Desarrollo

*Nota: Deliberadamente **no** emparejamos la red de Producción con la red de Desarrollo para mantener la arquitectura estricta (todo el tráfico debe pasar forzosamente por el Hub).*

### 5. Las Políticas de Aislamiento Estricto (NSG)
Incluso con el Peering configurado a nivel de red, aplicamos directivas *Firewall* adicionales nivel 4 (OSI) a través de **Network Security Groups (NSGs)** vinculados a las subredes de las máquinas Spoke:
- **`nsg-spoke-prod`:** Posee una regla de alta prioridad que deniega absolutamente cualquier paquete de red originado desde el rango de direcciones IP de Desarrollo (`10.2.0.0/16`).
- **`nsg-spoke-dev`:** Posee una regla espejo que deniega de tajo los paquetes entrantes desde Producción (`10.1.0.0/16`).

