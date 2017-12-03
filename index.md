---
title: 'Visualizações'
date: '2017-12-03'
---





## Introdução

Agora que já temos em mãos as ferramentas para importar, arrumar e transformar os nossos dados, é hora de começarmos a extrair informações deles. Seguindo o nosso bom e velho ciclo da ciência de dados, o próximo passo é a construção de *visualizações*.

<img src="img/data-science.png" title="plot of chunk unnamed-chunk-9" alt="plot of chunk unnamed-chunk-9" width="40%" height="40%" />

A visualização dos dados é uma etapa importantíssima da análise estatística, pois é a partir dela que criamos a intuição necessária para escolher o teste ou modelo mais adequado para o nosso problema.

Visualizações podem ser uma simples medida resumo (frequência, média, variância, mínimo, máximo, ...), um conjunto dessas medidas organizadas em uma tabela ou a representação (de uma parte) dos dados em um gráfico. Nesse tópico, focaremos na construção de gráficos, uma tarefa que, apesar de nem sempre ser conceitualmente ou tecnicamente trivial, é muito facilitada pelas ferramentas disponíveis no R.

Mas antes de mais nada, o que é um gráfico estatístico?

## O que é um gráfico?

A construção de gráficos no R foi revolucionada com a criação do pacote `ggplot2`, fruto da tese de doutorado de [Hadley Wickham](https://github.com/hadley). Essa revolução teve base na filosofia adotada por Hadley ao definir o que deveria ser um gráfico estatístico.

Mas será que podemos definir formalmente o que é um gráfico estatístico? Graças ao estatístico norte-americano Leland Wilkinson, a resposta é sim.

Em 2005, Leland publicou o livro [*The Grammar of graphics*](http://www.springer.com/statistics/computational+statistics/book/978-0-387-24544-7), uma fonte de princípios fundamentais para a construção de gráficos estatísticos. No livro, ele defende que um gráfico é o mapeamento dos dados a partir de atributos estéticos (posição, cor, forma, tamanho) de objetos geométricos (pontos, linhas, barras, caixas).

A partir dessa definição, Hadley escreveu [A Layered Grammar of Graphics](http://vita.had.co.nz/papers/layered-grammar.html), sugerindo que os principais aspectos de um gráfico (dados, sistema de coordenadas, rótulos e anotações) podiam ser divididos em camadas, construídas uma a uma na elaboração do gráfico. Essa é a essência do `ggplot2`.

Além de uma filosofia bem fundamentada, o `ggplot2` ainda traz outras vantagens em relação aos gráficos do r base:

- gráficos naturalmente mais bonitos;
- muito mais fácil deixar o gráfico do jeito que você quer;
- a estrutura padronizada das funções deixa o aprendizado muito mais intuitivo; e
- é possível criar uma imensa gama de gráficos com poucas linhas de código.

Para discutir os principais aspectos da construção de gráficos com o `ggplot2`, vamos utilizar inicialmente a base disponível no objeto `mtcars`. Essa base de 1974 contém dados extraídos da revista *Motor Trend US* sobre o consumo de combustível e características de performance e engenharia de 32 automóveis.

Se você não está familiarizado com esta base, rode `help(mtcars)` para mais informações.

Na próxima seção, vamos conhecer as principais funções do `ggplot2` e começar a construir nossos primeiros gráficos. Não se esqueça de instalar e carregar o pacote antes de tentar rodas os exemplos.


```r
install.packages("ggplot2")
library(ggplot2)
```

--------------------------------------------------------------------------------





## As camadas de um gráfico

No `ggplot2`, os gráficos são construídos camada por camada (ou, *layers*, em inglês), sendo a primeira delas dada pela função `ggplot()` (repare que não tem o "2"). Essa função recebe um data frame e cria a camada base do gráfico. Se rodarmos apenas a função `ggplot()`, obteremos um painel em branco.


```r
ggplot(data = mtcars)
```

<img src="figures//unnamed-chunk-12-1.png" title="plot of chunk unnamed-chunk-12" alt="plot of chunk unnamed-chunk-12" width="40%" height="40%" />

Apesar de termos passados os dados para a função, precisamos especificar como as observações serão mapeadas nos aspectos visuais do gráfico e quais formas geométricas serão utilizadas para isso. Cada camada do gráfico representará um tipo de mapeamento ou personalização. O código abaixo é um exemplo de um gráfico bem simples, construído a partir das duas principais camadas. 


```r
ggplot(data = mtcars) + 
  geom_point(mapping = aes(x = disp, y = mpg))
```

<img src="figures//grafico1-1.png" title="plot of chunk grafico1" alt="plot of chunk grafico1" width="40%" height="40%" />

A figura gerada pelo código acima é um gráfico de dispersão. Observe que:

- como vimos, a primeira camada é dada pela função `ggplot()` e recebe um data frame;
- a segunda camada é dada pela função `geom_point()`, especificando a forma **geom**étrica utilizada no mapeamento das observações;
- as camadas são somadas com um `+`;
- o mapeamento na função `geom_point()` recebe a função `aes()`, responsável por descrever como as variáveis serão mapeadas nos aspectos visuais da forma geométrica escolhida, no caso, pontos.

A combinação da função `ggplot()` e de uma ou mais funções `geom_()` definirá o tipo de gráfico gerado.

<div class='admonition note'>
<p class='admonition-title'>
Cuidado
</p>
<p>
As camadas dos gráficos são empilhadas utilizando-se o sinal +. Como a estrutura é muito parecida com uma pipe line, é comum trocarmos o + por um %>% no meio do código.
</p>
</div>

Podemos acrescentar uma terceira camada ao gráfico, agora com uma personalização. Repare como é simples acrescentar labels ao gráfico com a função `labs()`.


```r
ggplot(data = mtcars) + 
  geom_point(mapping = aes(x = disp, y = mpg)) +
  labs(x = "Cilindradas", y = "Milhas/galão")
```

<img src="figures//unnamed-chunk-13-1.png" title="plot of chunk unnamed-chunk-13" alt="plot of chunk unnamed-chunk-13" width="40%" height="40%" />

Agora que você já sabe como a estrutura de camadas do `ggplot` funciona, vamos estudar com mais atenção para que serve a função `aes()`.

--------------------------------------------------------------------------------





## Aesthetics

O papel da função `aes()` (de aesthetics, estética em inglês) é indicar a relação entre os dados e cada aspecto visual do gráfico, como qual variável será representada no eixo x, qual será representada no eixo y, a cor e o tamanho dos componentes geométricos etc. Os aspectos que podem ou devem ser mapeados depende do tipo de gráfico que você está construindo.

No exemplo anterior, atribuímos aspectos de posição: ao eixo y mapeamos a variável `mpg` (milhas por galão) e ao eixo x a variável `disp` (cilindradas). Note que os valores dos labels não são mapeados por variáveis, mas sim diretamente especificados.

Outro aspecto que pode ser mapeado nesse gráfico é a cor dos pontos:


```r
ggplot(data = mtcars) + 
  geom_point(mapping = aes(x = disp, y = mpg, color = as.factor(am)))
```

<img src="figures//mapear_am-1.png" title="plot of chunk mapear_am" alt="plot of chunk mapear_am" width="40%" height="40%" />

Agora, a variável `am` (tipo de transmissão) foi mapeada à cor dos pontos, com pontos vermelhos correspondendo à transmissão automática (valor 0) e pontos azuis à transmissão manual (valor 1). Observe que inserimos a variável `am` como um fator, pois temos interesse apenas nos valores "0" e "1". No entanto, também podemos mapear uma variável contínua à cor dos pontos:


```r
ggplot(mtcars) + 
  geom_point(mapping = aes(x = disp, y = mpg, colour = cyl))
```

<img src="figures//mapear_cor-1.png" title="plot of chunk mapear_cor" alt="plot of chunk mapear_cor" width="40%" height="40%" />

Aqui, o número de cilindros, `cyl`, é representado pela tonalidade da cor azul. Note que, por padrão, a legenda é inserida automaticamente ao gráfico.

Também podemos mapear o tamanho dos pontos a uma variável de interesse:


```r
ggplot(mtcars) +
  geom_point(mapping = aes(x = disp, y = mpg, color = cyl, size = wt))
```

<img src="figures//mapear_tamanaho-1.png" title="plot of chunk mapear_tamanaho" alt="plot of chunk mapear_tamanaho" width="40%" height="40%" />

Segue abaixo uma lista dos aspectos visuais mais utilizados:

- `color=`: altera a cor de formas que não têm área (pontos e retas).
- `fill=`: altera a cor de formas com área (barras, caixas, densidades, áreas).
- `size=`: altera o tamanho de formas.
- `type=`: altera o tipo da forma, geralmente usada para pontos.
- `linetype=`: altera o tipo da linha.

Até agora, sempre mapeamos um aspecto estético a uma variável. Muitas vezes 
queremos apenas modificar um aspecto sem mapeá-lo a variáveis.
Por exemplo, no gráfico a seguir, modificamos a cor de todos os pontos.


```r
ggplot(mtcars, aes(y = mpg, x = disp)) + 
  geom_point(color = "red")
```

<img src="figures//unnamed-chunk-14-1.png" title="plot of chunk unnamed-chunk-14" alt="plot of chunk unnamed-chunk-14" width="40%" height="40%" />

A principal diferença aqui é que especificamos o argumento `color=` fora da função
`aes()`. Dessa forma, podemos controlar todos os aspectos de uma forma geométrica.


```r
ggplot(mtcars, aes(y = mpg, x = disp)) + 
  geom_point(colour = "red", size = 2, shape = 3, alpha = 0.5)
```

<img src="figures//unnamed-chunk-15-1.png" title="plot of chunk unnamed-chunk-15" alt="plot of chunk unnamed-chunk-15" width="40%" height="40%" />

--------------------------------------------------------------------------------




## Geoms

Os *geoms* definem qual forma geométrica será utilizada para a visualização das observações. Como já vimos, a função `geom_point()` gera gráficos de dispersão
transformando pares $(x,y)$ em pontos. Veja a seguir outros *geoms* bastante utilizados:

- `geom_line` - para linhas definidas por pares (x,y).
- `geom_abline` - para retas definidas por um intercepto e uma inclinação.
- `geom_hline` - para retas horizontais.
- `geom_bar` - para barras.
- `geom_histogram` - para histogramas.
- `geom_boxplot` - para boxplots.
- `geom_density` - para densidades.
- `geom_area` - para áreas.

Veja a seguir como é fácil gerar diversos gráficos diferentes utilizando a mesma estrutura do gráfico de dispersão acima:


```r
ggplot(mtcars) + 
  geom_boxplot(aes(x = as.factor(cyl), y = mpg))
```

<img src="figures//unnamed-chunk-16-1.png" title="plot of chunk unnamed-chunk-16" alt="plot of chunk unnamed-chunk-16" width="40%" height="40%" />

Note que para fazer um boxplot para cada grupo, precisamos passar um fator para o aspecto x do gráfico.


```r
ggplot(mtcars) + 
  geom_histogram(aes(x = mpg))
## `stat_bin()` using `bins = 30`. Pick better value with `binwidth`.
```

<img src="figures//unnamed-chunk-17-1.png" title="plot of chunk unnamed-chunk-17" alt="plot of chunk unnamed-chunk-17" width="40%" height="40%" />

Enquanto o gráfico e dispersão demandam o mapeamento das posições x e y, o histograma requer apenas a posição x, já que, pela definição do gráfico, o eixo mostra a frequência de cada classe. O mesmo acontece com o gráfico de barras:


```r
ggplot(mtcars) + 
  geom_bar(aes(x = as.factor(cyl)))
```

<img src="figures//unnamed-chunk-18-1.png" title="plot of chunk unnamed-chunk-18" alt="plot of chunk unnamed-chunk-18" width="40%" height="40%" />

**Exercício**: explorar novos `geom()`'s e mexer nos mapeamentos estéticos desses novos gráficos. [Essa é uma
boa referência](http://ggplot2.tidyverse.org/articles/ggplot2-specs.html).

<div class='admonition note'>
<p class='admonition-title'>
Um padrão para os gráficos
</p>
<p>
Você deve ter percebido que, para fazer um gráfico usando `ggplot2` e a gramática
dos gráficos, existe um padrão:
<br> 
<br>
ggplot(data = DATA) + GEOM_FUNCTION(mapping = aes(MAPPINGS))
<br>
<br>
Para fazer um gráfico, basta substituir DATA por um banco de dados, GEOM_FUNCTION por
uma função geométrica e MAPPINGS por uma coleção de <b>mapas estéticos</b>. Isso será muito útil quando você for fazer o seu próprio gráfico.
</p>
</div>

Agora, considere os 2 gráficos a seguir.


```r
# esquerda
ggplot(mtcars) + 
  geom_point(aes(y = mpg, x = disp))
# direita
ggplot(mtcars) + 
  geom_smooth(aes(y = mpg, x = disp))
```

<img src="figures//duplochunk-1.png" title="plot of chunk duplochunk" alt="plot of chunk duplochunk" width="50%" height="40%" /><img src="figures//duplochunk-2.png" title="plot of chunk duplochunk" alt="plot of chunk duplochunk" width="50%" height="40%" />

Os gráficos são similares e se completam. O da esquerda, mostra como os pontos estão distribuídos, indicando uma relação entre as cilindradas e o consumo de gasolina. Já o gráfico da direita resume essa relação com uma curva de tendência e sua margem de confiança.

Como o `ggplot2` é pensado para que cada gráfico seja feito como uma combinação de camadas, é muito fácil sobrepor esses dois gráficos.


```r
ggplot(mtcars) + 
  geom_point(aes(y = mpg, x = disp)) +
  geom_smooth(aes(y = mpg, x = disp))
## `geom_smooth()` using method = 'loess'
```

<img src="figures//unnamed-chunk-19-1.png" title="plot of chunk unnamed-chunk-19" alt="plot of chunk unnamed-chunk-19" width="40%" height="40%" />

Desta forma, sobrepusemos os pontos e a linha de suavização. No entanto, duplicamos alguns trechos no nosso código, o que geralmente não é bom. Imagine se você precisar
mudar a variável do eixo `y`, você precisará trocar o nome da variável em mais de um
lugar do código. Para resolver isso, você pode definir o *mapping* apenas uma vez
dentro da declaração do gráfico, conforme o código a seguir.


```r
ggplot(mtcars, aes(y = mpg, x = disp)) + 
  geom_point() +
  geom_smooth()
## `geom_smooth()` using method = 'loess'
```

<img src="figures//unnamed-chunk-20-1.png" title="plot of chunk unnamed-chunk-20" alt="plot of chunk unnamed-chunk-20" width="40%" height="40%" />

Veja que isso gera o mesmo gráfico!

Veja que mesmo com dois `geom`'s, o `ggplot` segue a mesma regra para mapear as
variáveis para os aspectos visuais. Por exemplo, se você mapear uma variável para 
a cor, você obterá o seguinte gráfico.


```r
ggplot(mtcars, aes(y = mpg, x = disp, colour = as.factor(cyl))) + 
  geom_point() +
  geom_smooth(method = "lm")
```

<img src="figures//unnamed-chunk-21-1.png" title="plot of chunk unnamed-chunk-21" alt="plot of chunk unnamed-chunk-21" width="40%" height="40%" />

O `ggplot2` agora desenhou uma reta para cada um dos grupos de pontos e coloriu
cada grupo de pontos de uma cor diferente. Em alguns casos, você pode querer mapear
a cor em apenas uma das camadas do gráfico. Isso pode ser feito da seguinte forma:


```r
ggplot(mtcars, aes(y = mpg, x = disp)) + 
  geom_point(aes(colour = as.factor(cyl))) +
  geom_smooth(method = "lm")
```

<img src="figures//unnamed-chunk-22-1.png" title="plot of chunk unnamed-chunk-22" alt="plot of chunk unnamed-chunk-22" width="40%" height="40%" />

Agora, cada grupo de pontos tem uma cor, mas a reta é única para todos os pontos.

--------------------------------------------------------------------------------




## Facets

Uma funcionalidade muito útil do `ggplot2` é a possibilidade de usar `facets`.
Isso auxilia na visualização de diferentes subconjuntos dos dados em gráficos
separados, permitindo a visualização de comportamentos diferentes dependendo
do grupo.


```r
ggplot(mtcars, aes(y = mpg, x = disp)) + 
  geom_point() +
  geom_smooth(method = "lm") + 
  facet_wrap(~am)
```

<img src="figures//unnamed-chunk-23-1.png" title="plot of chunk unnamed-chunk-23" alt="plot of chunk unnamed-chunk-23" width="40%" height="40%" />

No gráfico acima, rapidamente conseguimos visualizar que se o carro não é automático o consumo de combustível é muito menor do que quando o carro é automático. Também conseguimos ver que a inclinação das retas é bem diferente dependendo do carro ser
automático/manual.

**Exercício**: pesquisar o que faz a função `facet_grid()`.

--------------------------------------------------------------------------------



## Personalizando

Como exemplo de personalização de um gráfico com o `ggplot2`, vamos partir de um simples boxplot e fazer diversas alterações nas legendas. 

Para isso, utilizaremos nessa seção a base contida no objeto `PlantGrowth`, contendo resultados de um experimento para comparar o crescimento de plantas sob três condições diferentes (um controle e dois tratamentos). Para mais informações, rode `help(PlantGrowth)`.

O gráfico inicial é construído da seguinte forma:


```r
bp <- ggplot(data = PlantGrowth, aes(x = group, y = weight, fill = group)) +
  geom_boxplot()

bp
```

<img src="figures//unnamed-chunk-24-1.png" title="plot of chunk unnamed-chunk-24" alt="plot of chunk unnamed-chunk-24" width="40%" height="40%" />

### Removendo totalmente a legenda

Existem diversas maneiras para remover a legenda de um gráfico no `ggplot2`. A forma mais simples é usar `guides(fill = FALSE)` com `fill` sendo o atributo gráfico do qual você deseja remover a legenda.


```r
bp + guides(fill = FALSE)
```

<img src="figures//unnamed-chunk-25-1.png" title="plot of chunk unnamed-chunk-25" alt="plot of chunk unnamed-chunk-25" width="50%" height="40%" />

Também é possível remover a legenda utilizando a função `scale_fill_discrite()`. A família `scale_X_Y()` de funções permite escolher manualmente os parâmetros de cada escala utilizada no gráfico.


```r
bp + scale_fill_discrete(guide = F)
```

<img src="figures//unnamed-chunk-26-1.png" title="plot of chunk unnamed-chunk-26" alt="plot of chunk unnamed-chunk-26" width="50%" height="40%" />

O comando a seguir remove todas as legendas, não importa o atributo que ela esteja representando.


```r
bp + theme(legend.position="none")
```

<img src="figures//unnamed-chunk-27-1.png" title="plot of chunk unnamed-chunk-27" alt="plot of chunk unnamed-chunk-27" width="40%" height="40%" />

### Alterando a ordem dos itens

Para alterar a ordem dos itens na legenda do gráfico no `ggplot2`, usamos o comando da escala de cores.


```r
bp + scale_fill_discrete(breaks=c("trt1", "ctrl", "trt2"))
```

<img src="figures//unnamed-chunk-28-1.png" title="plot of chunk unnamed-chunk-28" alt="plot of chunk unnamed-chunk-28" width="40%" height="40%" />

```r
bp
```

<img src="figures//unnamed-chunk-28-2.png" title="plot of chunk unnamed-chunk-28" alt="plot of chunk unnamed-chunk-28" width="40%" height="40%" />

Dependendo dos aspectos gráficos (cores, formatos, preenchimentos) especificados, você pode precisar usar alguma das seguintes funções: 

- `scale_fill_manual()`
- `scale_colour_hue()`
- `scale_colour_manual()`
- `scale_shape_discrete()`
- `scale_linetype_discrete()`

Você pode também querer inverter a ordem dos itens da legenda. Isso pode ser feito de uma das seguintes maneiras.


```r
bp + guides(fill = guide_legend(reverse = TRUE))
bp + scale_fill_discrete(guide = guide_legend(reverse = TRUE))
```

<img src="figures//unnamed-chunk-29-1.png" title="plot of chunk unnamed-chunk-29" alt="plot of chunk unnamed-chunk-29" width="50%" height="40%" /><img src="figures//unnamed-chunk-29-2.png" title="plot of chunk unnamed-chunk-29" alt="plot of chunk unnamed-chunk-29" width="50%" height="40%" />

### Removendo os títulos da legenda

Algumas vezes é necessário remover o título das legendas do gráfico feito no `ggplot2`. Veja a seguir algumas maneiras:


```r
# Remove o título apenas da legenda do preenchimento (fill).
bp + guides(fill=guide_legend(title=NULL))

# Remove o título de todas as legendas.
bp + theme(legend.title = element_blank())
```

<img src="figures//unnamed-chunk-30-1.png" title="plot of chunk unnamed-chunk-30" alt="plot of chunk unnamed-chunk-30" width="50%" height="40%" /><img src="figures//unnamed-chunk-30-2.png" title="plot of chunk unnamed-chunk-30" alt="plot of chunk unnamed-chunk-30" width="50%" height="40%" />

### Modificando texto, cores e rótulos

Existem duas formas para modificar os textos e rótulos das legendas. Uma delas é modificar o `data.frame` de forma com que os fatores tenham o mesmo nome que você deseja na legenda. Outra forma é usando as funções `scale_X_Y()`. 

No nosso exemplo, como a variável `group` está associada ao atributo `fill`, usamos as funções `scale_fill_discrete()`. e `scale_fill_manual()`. Utilizamos a primeira se não quisermos alterar as cores padrão, mas sim que cada fator esteja associado uma cor diferente. Mudamos também os rótolos e o título da legenda.


```r
bp + scale_fill_discrete(name = "Experimental\nCondition",
                         breaks = c("ctrl", "trt1", "trt2"),
                         labels = c("Control", "Treatment 1", "Treatment 2"))
```

<img src="figures//unnamed-chunk-31-1.png" title="plot of chunk unnamed-chunk-31" alt="plot of chunk unnamed-chunk-31" width="50%" height="40%" />

Usamos a segunda se quisermos alterar as cores padrão. Aqui, escolhemos as cores da escala hexadecimal. Veja que isso não aletrou o eixo x do gráfico.


```r
bp + scale_fill_manual(values=c("#999999", "#E69F00", "#56B4E9"), 
                       name="Experimental\nCondition",
                       breaks=c("ctrl", "trt1", "trt2"),
                       labels=c("Control", "Treatment 1", "Treatment 2"))
```

<img src="figures//unnamed-chunk-32-1.png" title="plot of chunk unnamed-chunk-32" alt="plot of chunk unnamed-chunk-32" width="50%" height="40%" />

### Modificando a aparência da legenda

Existem inúmeras modificações que podem ser realizadas na aparência da legenda. Todas elas estão relacionadas à modificação do `element_text()`. Veja neste [link](http://docs.ggplot2.org/0.9.2.1/element_text.html) todos os atributos que podem ser modificados.


```r
# Mudando a aparência do título
bp + theme(legend.title = element_text(color = "blue", size = 16, face = "bold"))
```

<img src="figures//unnamed-chunk-33-1.png" title="plot of chunk unnamed-chunk-33" alt="plot of chunk unnamed-chunk-33" width="40%" height="40%" />


```r
# Mudando a aparência dos rótulos
bp + theme(legend.text = element_text(colour = "blue", size = 16, face = "bold"))
```

<img src="figures//unnamed-chunk-34-1.png" title="plot of chunk unnamed-chunk-34" alt="plot of chunk unnamed-chunk-34" width="40%" height="40%" />

### Modificando a posição da legenda

É possível controlar a posição da legenda facilmente escolhendo uma das posições:  `left`, `right`, `top` e `bottom`.


```r
bp + theme(legend.position="top")
```

<img src="figures//unnamed-chunk-35-1.png" title="plot of chunk unnamed-chunk-35" alt="plot of chunk unnamed-chunk-35" width="40%" height="40%" />

Também é possível controlar a posição da legenda de forma precisa usando a função `theme()`. A legenda será posicionada dentro do gráfico com o ponto central sendo o valor do argumento `legend.position=`. Esses valores são definidos de forma que o ponto (0,0) seja o canto inferior esquerdo e (1,1) seja o canto superior direito.


```r
bp + theme(legend.position=c(.5, .5))
```

<img src="figures//unnamed-chunk-36-1.png" title="plot of chunk unnamed-chunk-36" alt="plot of chunk unnamed-chunk-36" width="40%" height="40%" />

--------------------------------------------------------------------------------




## Exercícios

--------------------------------------------------------------------------------

**1.** 

O que tem de errado no código abaixo? Por que os pontos não ficaram azuis?


```r
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
```

<img src="figures//unnamed-chunk-37-1.png" title="plot of chunk unnamed-chunk-37" alt="plot of chunk unnamed-chunk-37" width="40%" height="40%" />

--------------------------------------------------------------------------------

**2.** 

Mapeie uma variável contínua para uma cor, tamanho e forma. Como essas formas
estéticas se comportam diferente para variáveis categóricas vs contínuas?

--------------------------------------------------------------------------------

**3.**

O que acontece se você rodar `ggplot(data = mtcars)`?

--------------------------------------------------------------------------------

**4.**

Utilizando o `mtcars`, faça um gráfico de dispersão de `mpg` por `qsec`.

--------------------------------------------------------------------------------

**5.**

Utilizando o `mtcars`, o que acontece se você fizer um gráfico de dispersão de `vs` por `mpg`? Por que o gráfico não é útil?

--------------------------------------------------------------------------------
