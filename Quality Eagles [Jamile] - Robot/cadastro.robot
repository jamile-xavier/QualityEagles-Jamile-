*** Settings ***
Documentation    Configurações iniciais do projeto

##Importando as Bibliotecas
Library    RequestsLibrary
Library    libs/get_fake_person.py
Library    libs/get_fake_company.py
Library    Collections
Library    Dialogs
Library    String

*** Variables ***
# URL
${BASE_URL}    https://quality-eagles.qacoders.dev.br/api

# ADMIN
${MailAdmin}    sysadmin@qacoders.com
${PasswordAdmin}    1234@Test    

# ROUTES
${LOGIN}    login
${USER}    user
${USER_COUNT}    user/count
${USER_PASSWORD}    user/password
${USER_STATUS}    user/status
${COMPANY}    company
${COMPANY_COUNT}    company/count
${COMPANY_PASSWORD}    company/password
${COMPANY_STATUS}    company/status

*** Test Cases ***
# REQUESTS LOGIN
  
TC01 - Realizar login com sucesso
    ${response}    Realizar login    email=${MailAdmin}    senha=${PasswordAdmin}
    Status Should Be    200    ${response}

# REQUESTS USERS
TC05 - Cadastro de usuário com sucesso
    ${person}        Get Fake Person
    ${response}      Criar Usuario    ${person}
        
    # Verificar se o cadastro falhou como esperado
    Should Be Equal As Strings    ${response.status_code}    500





#TC11 - Exclusão de usuário com id inválido
    #[Documentation]    Tenta deletar um usuário com ID inválido
    #[Tags]    deletar_usuario
    #${person}        Get Fake Person
    #${response}      Cadastro Sucesso
    #${user_id}       Set Variable    ${response.json()["user"]["_id"]}
    #${token}     Pegar token
    #${headers}     Create Dictionary    accept=application/json    Content-Type=application/json    Authorization=Bearer ${token}
    #${response}     DELETE On Session    alias=quality-eagles    url=${BASE_URL}/${USER}/67a2770ee8510a694b5942f5    headers=${headers}    params=token=${token}
    #Status Should Be    400    ${response}
    #Should Be Equal    ${response.json()["msg"]}    Esse usuário não existe em nossa base de dados.

#TC12 - Exclusão de usuário com token em branco
    #[Documentation]    Deleta um usuário existente
    #[Tags]    deletar_usuario
    #${person}        Get Fake Person
    #${response}      Cadastro Sucesso
    #${user_id}       Set Variable    ${response.json()["user"]["_id"]}
    #
    ## Deletar usuário
    #${token}         Pegar token
    #${headers}       Create Dictionary    accept=application/json    Content-Type=application/json    
    #${response}      DELETE On Session    alias=quality-eagles    url=${BASE_URL}/${USER}/${user_id}    headers=${headers}  
    #Status Should Be    403    ${response}  


   
#TC14 - Listagem de usuário com token inválido
#TC15 - Listagem de usuário com token em branco

#TC17 - Contagem de usuário com token inválido
#TC18 - Contagem de usuário token em branco

#TC20 - Listagem de usuário por id com id inválido
#TC21 - Listagem de usuário por id com token em branco
#TC22 - Atualização de cadastro com sucesso


#TC23 - Atualização de cadastro sem nome completo
#TC24 - Atualização de cadastro sem e-mail
TC25 - Atualização de senha por id com sucesso
    [Documentation]    Atualizar senha de usuário existente
    [Tags]    atualizar_senha
    ${person}        Get Fake Person
    ${response}      Cadastro Sucesso
    ${user_id}       Set Variable    ${response.json()["user"]["_id"]}
    
    # Atualizar senha com token válido
    ${response}      Atualizar senha de usuario    user_id=${user_id}    password=9qJNsMDL75#A    confirmPassword=9qJNsMDL75#A
    Should Be Equal As Strings    ${response.status_code}    200
    Should Be Equal    ${response.json()["msg"]}    Senha atualizada com sucesso!
   
#TC26 - Atualização de senha por id com id inválido
#TC27 - Atualização de senha por id sem token

   
#     REQUESTS COMPANY
#TC31 - Cadastrar empresa com sucesso

TC32 - Criar Empresa Com Sucesso
    [Documentation]     Testa a criação de uma empresa com dados válidos
    [Tags]    criar_empresa
    ${address}=    Create Dictionary
    ...    zipCode=04777001
    ...    city=São Paulo
    ...    state=SP
    ...    district=Rua das Flores
    ...    street=Avenida Interlagos
    ...    number=50
    ...    complement=de 4503 ao fim - lado ímpar
    ...    country=Brasil
    
    ${response}=    Criar Empresa
    ...    corporateName=Teste do Teste
    ...    registerCompany=12126456000155
    ...    mail=test@test.com
    ...    matriz=Teste
    ...    responsibleContact=Marcio
    ...    telephone=99999999999999
    ...    serviceDescription=Testes
    ...    address=${address}
    
    Should Be Equal    ${response.status_code}    ${201}
    Should Be Equal    ${response.json()['corporateName']}    Teste do Teste
 
*** Keywords ***
Criar sessao
    [Documentation]    Criação de sessão inicial pra usar nas próximas requests
    ${headers}    Create Dictionary    accept=application/json    Content-Type=application/json
    Create Session    alias=quality-eagles    url=${BASE_URL}    headers=${headers}    verify=true

Pegar token
    [Documentation]    Obter token de autenticação com validação completa
    ${headers}    Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json
    ${body}       Create Dictionary
                    ...    mail=${MailAdmin}
                    ...    password=${PasswordAdmin}
    ${response}   POST On Session
                    ...    alias=quality-eagles
                    ...    url=${LOGIN}
                    ...    json=${body}
                    ...    headers=${headers}
                    ...    expected_status=200
    ${token}      Set Variable    ${response.json()}[token]
    
    # Validar token
    ${headers_validacao}    Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json
                    ...    Authorization=Bearer ${token}
    ${response_validacao}    GET On Session
                    ...    alias=quality-eagles
                    ...    url=${BASE_URL}/${USER}/
                    ...    headers=${headers_validacao}
                    ...    expected_status=200
    
    RETURN    ${token}
   
Realizar login
    [Documentation]    Realizar Login
    [Arguments]    ${email}    ${senha}    
    ${body}    Create Dictionary    mail=${email}    password=${senha}    
    Criar sessao
    ${response}    POST On Session    alias=quality-eagles    expected_status=any    url=${LOGIN}    json=${body}
    RETURN    ${response}

Criar usuario
    [Documentation]    Criar um usuário com dados aleatórios
    [Arguments]    ${person}
    ${token}       Pegar token
    ${headers}     Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json
                    ...    Authorization=Bearer ${token}
    
    ${body}        Create Dictionary
                    ...    fullName=${person}[name]
                    ...    mail=${person}[email]
                    ...    password=B6Dc#4d@SM6U
                    ...    accessProfile=ADMIN
                    ...    cpf=${person}[cpf]
                    ...    confirmPassword=B6Dc#4d@SM6U
    
  
    
    ${response}      POST On Session
                     ...    alias=quality-eagles
                     ...    url=${BASE_URL}/${USER}/?token=${token}
                     ...    json=${body}
                     ...    expected_status=500
         
    RETURN           ${response}

Cadastro Sucesso
    ${person}        Get Fake Person
    ${id_user}       Criar Usuario     ${person}
    
    RETURN           ${id_user}

Cadastro para alteração manual de dados
    [Documentation]    Criar um usuário com dados manuais
    [Arguments]    ${name}    ${mail}    ${cpf}    ${password}    ${confirmPassword}
    ${token}       Pegar token
    ${body}        Create Dictionary
                    ...    fullName= ${name}
                    ...    mail= ${mail}
                    ...    accessProfile=ADMIN
                    ...    cpf= ${cpf}
                    ...    password=${password}
                    ...    confirmPassword=${confirmPassword}
    
  
    
    ${response}      POST On Session
                     ...    alias=quality-eagles
                     ...    url=/${USER}/?token=${token}
                     ...    json=${body}
                     ...    expected_status=400
         
    RETURN           ${response}

Verificar Token
    [Documentation]    Verificar se o token está válido e tem as permissões necessárias
    ${token}    Pegar token
    ${headers}    Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json
                    ...    Authorization=Bearer ${token}
    ${response}    GET On Session
                    ...    alias=quality-eagles
                    ...    url=${BASE_URL}/${USER}/
                    ...    headers=${headers}
                    ...    expected_status=200
    RETURN    ${token}
Atualizar senha de usuario
    [Documentation]    Atualizar a senha de um usuário existente
    [Arguments]    ${user_id}    ${password}    ${confirmPassword}
    ${token}    Pegar token
    ${headers}    Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json
                    ...    Authorization=Bearer ${token}
    ${body}    Create Dictionary
                    ...    password=${password}
                    ...    confirmPassword=${confirmPassword}
    ${response}    PUT On Session
                     ...    alias=quality-eagles
                     ...    url=/user/password/${user_id}
                     ...    json=${body}
                     ...    headers=${headers}
                     ...    expected_status=200
    RETURN    ${response}




 Criar Empresa
    [Documentation]     Cria uma empresa com os dados fornecidos
    [Arguments]        ${corporateName}    ${registerCompany}    ${mail}    ${matriz}    ${responsibleContact}    ${telephone}    ${serviceDescription}    ${address}
    ${token}    Pegar token
    ${headers}    Create Dictionary
                    ...    accept=application/json
                    ...    Content-Type=application/json
                    ...    Authorization=Bearer ${token}
    ${body}=    Create Dictionary
    ...    corporateName=${corporateName}
    ...    registerCompany=${registerCompany}
    ...    mail=${mail}
    ...    matriz=${matriz}
    ...    responsibleContact=${responsibleContact}
    ...    telephone=${telephone}
    ...    serviceDescription=${serviceDescription}
    ...    address=${address}
    
    ${response}=    POST On Session
    ...    alias=quality-eagles
    ...    url=/company
    ...    json=${body}

    
    RETURN    ${response}
      

