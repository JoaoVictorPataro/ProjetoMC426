# ProjetoMC426
O projeto em questão tem como objetivo fazer um sistema de consulta sobre os dados de segurança de Barão Geraldo, exibindo estatísticas de lugares e horários mais e menos seguros.


**Integrantes:**
| Nome                           | R.A.   |
|:------------------------------:|:------:|
| João Augusto Pimentel Barbosa  | 248341 |
| João Victor de Oliveira Pátaro | 237763 |
| Mateus de Padua Vicente        | 239829 |
| Vítor de Melo Calhau           | 248740 |


# Descrição da Arquitetura
Estilo arquitetural adotado: MVC (Model-View-Controller), visando dividir a aplicação em 3 módulos independentes que possuem suas próprias responsabilidades e funcionalidades, a Model (que possui os modelos de dados e serviços da aplicação), a View (parte da interface gráfica com o usuário, o "front-end") e os Controllers (controlador que é responsável por sincronizar o modelo com o front-end, passando os dados necessários para que os resultados das operações dos serviços sejam mostrados corretamente).

Para a parte do padrão de projeto, escolhemos adotar um para o componente de estatísticas de ocorrências. O padrão escolhido foi o padrão comportamental Strategy, que define um grupo de algoritmos, encapsula cada um deles e os torna intercambiáveis, permitindo que eles variem independentemente das classes que irão utilizá-los e compartimentando as responsabilidades. No nosso caso, teremos querys para puxar os dados de ocorrências de acordo com os filtros escolhidos pelo usuário. Podemos criar uma interface chamada Estatistica que contém o método ObterEstatistica e executá-lo em uma classe específica apenas para executar querys, e implementamos as querys específicas por filtragem (teríamos uma classe para cada tipo de filtragem, cada qual possuirá seus próprios métodos para criar a query de acordo com os dados escolhidos pelo usuário). Com isso, conseguimos que a classe de executar querys não seja alterada caso surja um novo filtro, já que ela não depende dos filtros, apenas da abstração, deixando um caminho mais fácil para evoluirmos com a aplicação.
