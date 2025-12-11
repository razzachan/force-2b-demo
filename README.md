# Force 2B - MVP Demo

## 🚀 Demonstração Interativa do Copiloto de Vendas com IA

### O que é este projeto?

Este é um **MVP Demo funcional** do Force 2B, desenvolvido para apresentação e validação de conceito. Todo o frontend está completo e funcional com dados mockados, permitindo demonstrar toda a experiência do usuário sem necessidade de backend.

### ✨ Funcionalidades Implementadas

#### 1. **Tela de Login**
- Animação de entrada suave
- Design profissional e responsivo
- Login mockado (qualquer credencial funciona)

#### 2. **Home com Alertas da IA**
- Dashboard inicial com métricas rápidas
- **Alertas Prioritários** com IA:
  - Risco de churn
  - Oportunidades de upsell
  - Anomalias detectadas
  - Pendências urgentes
- Lista de visitas do dia
- Cards de métricas (visitas, meta, alertas)

#### 3. **Roteiro Inteligente**
- Lista de clientes **priorizada por IA**
- Critérios: Geografia + Risco + Oportunidade
- Indicadores visuais de prioridade
- Métricas por cliente:
  - Ticket médio
  - Última compra
  - Probabilidade de recompra
- **Insights da IA** em tempo real

#### 4. **Detalhes do Cliente**
- Perfil completo do cliente
- Métricas principais (total comprado, ticket médio, visitas)
- **Alertas específicos da IA** quando em risco
- **Gráfico de histórico de compras** (6 meses)
- Lista de produtos mais comprados
- Sugestões de ações da IA

#### 5. **Novo Pedido com IA**
- **Sugestões de produtos pela IA** com probabilidade de compra
- Busca inteligente de produtos
- Carrinho interativo
- Cálculo automático de totais
- Produtos destacados que a IA recomenda
- Fluxo completo de finalização

#### 6. **Dashboard do Gestor**
- **KPIs Executivos**:
  - Receita total
  - Ticket médio
  - Total de clientes
  - Clientes em alto risco
- **Gráfico de performance** de vendas (6 meses)
- **Distribuição de risco de churn** (gráfico de pizza)
- Lista de clientes prioritários para atenção
- **Insights da IA** sobre a operação

### 🎨 Design e UX

- **Tema profissional** em azul corporativo
- **Ícones e badges** para rápida identificação
- **Cores semânticas**:
  - Verde: Sucesso / Baixo risco
  - Amarelo: Atenção / Médio risco
  - Vermelho: Urgente / Alto risco
- **Animações suaves** e transições fluidas
- **Responsivo** para diferentes tamanhos de tela
- **Tipografia clara** (Google Fonts - Inter)

### 📊 Dados Mockados

- **6 clientes** com perfis variados
- **10 produtos** em diferentes categorias
- **4 alertas** ativos de diferentes tipos
- Históricos realistas de compra
- Métricas calculadas dinamicamente

### 🛠 Tecnologias Utilizadas

- **Flutter 3.24.5** - Framework multiplataforma
- **Dart** - Linguagem de programação
- **FL Chart** - Gráficos interativos
- **Google Fonts** - Tipografia
- **Material Design 3** - Design system

### 🚀 Como Executar

#### Executar no Navegador
```powershell
cd "c:\Force 2B\force_2b_demo"
..\flutter\bin\flutter.bat run -d chrome
```

O aplicativo abrirá automaticamente no Chrome.

#### Build para Produção (Web)
```powershell
..\flutter\bin\flutter.bat build web
```

Os arquivos estarão em `build/web/`

### 📱 Navegação do App

```
Login → Home (3 abas)
         ├── Início (Alertas e Métricas)
         ├── Roteiro (Clientes Priorizados)
         └── Dashboard (Visão Executiva)

Home → Cliente Detalhes → Novo Pedido → Finalizar

Roteiro → Cliente Detalhes → Novo Pedido
```

### 🎯 Pontos de Destaque para a Apresentação

1. **IA Prescritiva em Ação**
   - Mostre os alertas de churn
   - Demonstre as sugestões de produtos
   - Destaque a priorização inteligente do roteiro

2. **Experiência do Vendedor**
   - 2 toques para pedido
   - Informações sempre visíveis
   - Ações claras sugeridas pela IA

3. **Visão do Gestor**
   - Previsibilidade com métricas
   - Identificação rápida de riscos
   - Insights acionáveis

4. **Design Profissional**
   - Interface moderna e limpa
   - Cores semânticas intuitivas
   - Gráficos executivos

### 🔄 Próximos Passos (Após Aprovação)

1. **Backend e APIs**
   - Go + PostgreSQL + ElasticSearch
   - Integração com ERPs
   - Pipeline de IA

2. **Modelos de Machine Learning**
   - Treinamento com dados reais
   - Predição de churn
   - Recomendação de produtos

3. **Funcionalidades Offline**
   - Sincronização incremental
   - Cache inteligente
   - Resolução de conflitos

4. **App Mobile Nativo**
   - iOS e Android
   - Otimizações de performance
   - Features específicas mobile

---

**Force 2B** - IA que transforma dados em ação 🚀
