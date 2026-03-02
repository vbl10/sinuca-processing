# Sinucão do Kleyson

2D pool game desenvolvido em **Processing** como parte da disciplina de Computação Visual. O projeto foi implementado em **Java**, seguindo princípios de **Programação Orientada a Objetos (OOP)** e com foco em **simulação física realista** para dinâmica e colisão de bolas.

---

## 🧩 Arquitetura e Detalhes Técnicos

### 1. Estrutura Geral

O projeto foi estruturado de forma modular, separando responsabilidades em diferentes classes e componentes principais:

- **Game**: controle do loop principal (update/render), gerenciamento de estados e modos de jogo.
- **Ball**: representação das bolas, incluindo propriedades físicas (posição, velocidade, massa, raio).
- **Table**: definição da geometria da mesa, limites físicos e caçapas.
- **Physics Engine**: responsável pela atualização do movimento e resolução de colisões.
- **GUI System**: sistema de interface customizado, incluindo botões, barra de força e seleção de ferramentas.
- **Input Handler**: tratamento de eventos de mouse e teclado.

O ciclo principal segue o padrão típico do Processing:

1. Leitura de input  
2. Atualização do estado do jogo  
3. Cálculo da física  
4. Renderização dos elementos  

---

### 2. Simulação Física

A simulação foi implementada manualmente, sem uso de engines externas.

#### 2.1. Dinâmica das Bolas

Cada bola possui:

- Vetor posição `P`
- Vetor velocidade `V`
- Massa `m`
- Raio `r`

A movimentação é calculada por:

- Integração discreta (Euler explícito)
- Aplicação de desaceleração por atrito
- Limitação inferior de velocidade para evitar drift numérico

#### 2.2. Colisão Bola–Bola

- Detecção baseada na distância entre centros.
- Resolução usando conservação de momento linear.
- Cálculo do vetor normal de colisão.
- Separação posicional para evitar interpenetração.
- Transferência de energia considerando colisão elástica ideal.

#### 2.3. Colisão Bola–Borda

- Verificação contra limites da mesa.
- Reflexão do vetor velocidade em relação ao eixo da borda.
- Aplicação de coeficiente de restituição.

#### 2.4. Sistema de Predição de Trajetória

Dependendo da dificuldade:

- Simulação auxiliar projetando o vetor de movimento.
- Cálculo do ponto de colisão previsto.
- Renderização de linha guia.
- Em níveis mais fáceis, simulação adicional da trajetória pós-colisão.

---

### 3. Sistema de Câmera e Transformações

A mesa pode ser:

- Movida (translação)
- Rotacionada
- Aplicado zoom

Isso é feito através de transformações geométricas:

- Matrizes de transformação
- Aplicação de `translate`, `rotate` e `scale` do Processing
- Conversão entre coordenadas de tela e coordenadas do mundo

---

### 4. Interface Gráfica (GUI)

Sistema de GUI desenvolvido do zero, incluindo:

- Botões com detecção de clique
- Ícones vetoriais
- Barra vertical dinâmica de força
- Sistema de ferramentas (estado ativo)

A GUI opera em um sistema de coordenadas separado do mundo físico da mesa.

---

## 5. Modos de Jogo

### 5.1. Corrida Contra o Tempo

- Encaçape todas as bolas exceto a branca no menor tempo possível  
- Se encaçapar a bola branca, é fim de jogo  

### 5.2. Livre

- Permite jogar sem regras rígidas  
- Não há fim de jogo  
- É possível recuperar qualquer bola encaçapada  

---

## 6. Como Jogar

### 6.1. Realizar tacada

- Clique na bola branca para iniciar uma tacada  
- Use a roda do mouse para ajustar a força  
- Confira a força na barra vertical no canto esquerdo  
- Mova o mouse para escolher a direção  
- Clique novamente para realizar a tacada  
- Certifique-se de estar na ferramenta "jogar" (botão de play no canto superior esquerdo)  

### 6.2. Pausa

- Clique no botão de lista no canto superior esquerdo para pausar o jogo  

---

## 7. Ferramentas

### 7.1. Mover

- Clique no botão de cruz no canto superior esquerdo ou use botão direito do mouse  
- Clique com botão esquerdo para iniciar movimento da mesa  
- Clique novamente para finalizar  
- Use roda do mouse para zoom  
- Use teclas "x" e "z" para girar a mesa  

### 7.2. Posicionar Bola (modo Livre)

- Clique no botão de mão no canto superior esquerdo  
- Clique com botão esquerdo para mover uma bola  
- Clique novamente para soltar  
- Use a régua de bolas no topo para remover ou restaurar bolas  

---

## 8. Dificuldades

|           | Predição de trajetória | Predição pós-colisão |
|-----------|------------------------|----------------------|
| Fácil     | ✔️                     | ✔️                   |
| Médio     | ✔️                     | ❌                   |
| Difícil   | ❌                     | ❌                   |

---

## 9. Tecnologias Utilizadas

- Java  
- Processing  
- Programação Orientada a Objetos (OOP)  
- Simulação física 2D  
- Desenvolvimento de GUI customizada  
- Computação Visual  
- Desenvolvimento de Jogos  
