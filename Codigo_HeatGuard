import flet as ft
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
import io
import base64
import time

# Configuramos Matplotlib para que no intente abrir ventanas externas
matplotlib.use('Agg')

def main(page: ft.Page):
    page.title = "HeatGuard"
    page.window_width = 1000
    page.window_height = 800
    page.theme_mode = "dark"

    # --- VARIABLES DE ESTADO ---
    datos_rastreo = []
    es_rastreando = False

    # --- LÓGICA DE CÁLCULO ---
    def calcular_campo_termico(x, y, puntos):
        if not puntos: return 0
        pesos_totales = 0
        temp_acumulada = 0
        for px, py, pt in puntos:
            # Fórmula de Distancia Inversa Ponderada (IDW)
            dist = np.sqrt((x - px)**2 + (y - py)**2) + 0.5
            peso = 1 / (dist**2)
            temp_acumulada += pt * peso
            pesos_totales += peso
        return temp_acumulada / pesos_totales

    # --- COMPONENTES DE INTERFAZ ---
    # Usamos un placeholder inicial para que no salga el error rojo
    img_mapa = ft.Image(
        src="https://via.placeholder.com/500x400?text=Inicie+Rastreo+para+Generar+Mapa",
        width=500,
        height=400,
        fit="contain",
    )
    
    texto_estado = ft.Text("Sistema Listo", color="blue", size=20, weight="bold")
    lista_lecturas = ft.ListView(expand=1, spacing=5, padding=10)

    def actualizar_grafica():
        if len(datos_rastreo) < 3: # Necesitamos al menos 3 puntos para un mapa coherente
            texto_estado.value = "⚠️ Necesitas al menos 3 puntos para el mapa"
            page.update()
            return
        
        # 1. Crear malla de datos
        x_lin = np.linspace(0, 10, 50)
        y_lin = np.linspace(0, 10, 50)
        X, Y = np.meshgrid(x_lin, y_lin)
        
        # 2. Calcular Z
        Z = np.vectorize(lambda x, y: calcular_campo_termico(x, y, datos_rastreo))(X, Y)

        # 3. Dibujar con Matplotlib
        plt.figure(figsize=(6, 5))
        plt.clf()
        cp = plt.contourf(X, Y, Z, levels=20, cmap='magma')
        plt.colorbar(cp, label='Temperatura °C')
        plt.title("Distribución Térmica Estimada")
        
        # 4. Guardar en memoria (Bytes)
        buf = io.BytesIO()
        plt.savefig(buf, format='png')
        plt.close()
        
        # 5. CODIFICAR Y REFRESCAR (Punto clave)
        img_mapa.src_base64 = base64.b64encode(buf.getvalue()).decode()
        # Cambiamos el src a un valor dummy para forzar el refresco del componente
        img_mapa.src = f"data:image/png;base64,{img_mapa.src_base64}"
        page.update()

    def al_pulsar_boton(e):
        nonlocal es_rastreando
        es_rastreando = not es_rastreando
        
        if es_rastreando == True:
            btn_accion.str = "DETENER RASTREO"
            btn_accion.bgcolor = "red"
            texto_estado.value = "🔴 Registrando datos..."
        elif es_rastreando == False:
            btn_accion.str = "INICIAR RASTREO"
            btn_accion.bgcolor = "green"
            texto_estado.value = "✅ Calculando mapa de calor..."
            page.update()
            # Un pequeño delay ayuda a que la UI no se bloquee mientras calcula
            time.sleep(0.5)
            actualizar_grafica()
        page.update()

    def agregar_lectura_manual(e):
        if es_rastreando:
            x, y = np.random.uniform(0, 10), np.random.uniform(0, 10)
            temp = np.random.uniform(18, 40)
            datos_rastreo.append((x, y, temp))
            lista_lecturas.controls.insert(0, ft.Text(f"Punto ({x:.1f}, {y:.1f}) -> {temp:.1f}°C", size=12))
            page.update()

    btn_accion = ft.ElevatedButton("INICIAR RASTREO", on_click=al_pulsar_boton, bgcolor="green", color="white")
    btn_simular = ft.FilledButton("Simular Captura de Sensor", on_click=agregar_lectura_manual)

    # --- DISEÑO FINAL ---
    page.add(
        ft.Row([
            ft.Column([
                ft.Text("HeatGuard", size=25, weight="bold", color="orange"),
                ft.Text("Panel de Control", size=20, weight="bold"),
                btn_accion,
                btn_simular,
                texto_estado,
                ft.Divider(),
                ft.Text("Historial (X, Y, T):"),
                lista_lecturas
            ], width=300),
            ft.Column([
                ft.Text("Visualización de Campo Escalar", size=20, weight="w500"),
                ft.Container(img_mapa, border=ft.border.all(1, "grey300"), border_radius=10),
                ft.Text("Zonas oscuras = Menor Temperatura (Frio)", color="grey600")
            ], expand=True)
        ], expand=True)
    )

if __name__ == "__main__":
    ft.app(target=main)
