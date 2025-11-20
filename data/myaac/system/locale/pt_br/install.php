<?php
/**
 * Brazilian Portuguese language file
 * install.php
 *
 * @author Ivens Pontes <ivenscardoso@hotmail.com>
 */
$locale['installation'] = 'Instalação';
$locale['steps'] = 'Passos';

$locale['previous'] = 'Anterior';
$locale['next'] = 'Próximo';

$locale['on'] = 'On';
$locale['off'] = 'Off';

$locale['loaded'] = 'Carregado';
$locale['not_loaded'] = 'Não carregado';

$locale['loading_spinner'] = 'Por favor aguarde, instalando...';
$locale['importing_spinner'] = 'Por favor, aguarde, importando dados...';
$locale['please_fill_all'] = 'Por favor, preencha todas as entradas!';
$locale['already_installed'] = 'MyAAC já foi instalado. Por favor, apague o diretório <b> install/ </b>. Se você quiser reinstalar o MyAAC - exclua o arquivo <strong> config.local.php </strong> do diretório principal e atualize a página.';

// welcome
$locale['step_welcome'] = 'Bem vindo';
$locale['step_welcome_title'] = 'Bem vindo ao instalador';
$locale['step_welcome_desc'] = 'Escolha o idioma que você gostaria de ver no instalador';

// license
$locale['step_license'] = 'Licença';
$locale['step_license_title'] = 'Licença GNU/GPL';

// requirements
$locale['step_requirements'] = 'Requisitos';
$locale['step_requirements_title'] = 'Verificação de requisitos';
$locale['step_requirements_php_version'] = 'Versão do PHP';
$locale['step_requirements_write_perms'] = 'Permissões de gravação';
$locale['step_requirements_failed'] = 'A instalação será desativada até que esses requisitos sejam aprovados..</b><br/>Para mais informações veja o arquivo <b>README</b>.';
$locale['step_requirements_extension'] = 'Extensão PHP $EXTENSION$ ';

// config
$locale['step_config'] = 'Configuração';
$locale['step_config_title'] = 'Configuração básica';
$locale['step_config_server_path'] = 'Caminho da pasta do servidor';
$locale['step_config_server_path_desc'] = 'Caminho para seu diretório principal do Canary, onde você tem o config.lua localizado.';
$locale['step_config_mail_admin'] = 'E-mail de administrador';
$locale['step_config_mail_admin_desc'] = 'Endereço em que os emails do formulário de contato serão entregues, por exemplo admin@gmail.com';
$locale['step_config_mail_admin_error'] = 'E-mail de administrador não está correto.';
$locale['step_config_mail_address'] = 'E-mail do servidor';
$locale['step_config_mail_address_desc'] = 'Endereço que será usado para emails de saída (de :), por exemplo no-reply@your-server.org';
$locale['step_config_mail_address_error'] = 'E-mail do servidor não está correto.';
$locale['step_config_timezone'] = 'Fuso horário';
$locale['step_config_timezone_desc'] = 'Usado para funções de data.';
$locale['step_config_timezone_error'] = 'O fuso horário não está correto.';
$locale['step_config_client'] = 'Versão do cliente';
$locale['step_config_client_desc'] = 'Usado para a página de download e alguns modelos.';
$locale['step_config_client_error'] = 'O cliente não está correto.';

// database
$locale['step_database'] = 'Importar schema';
$locale['step_database_title'] = 'Importar MySQL schema';
$locale['step_database_importing'] = 'Seu banco de dados é o MySQL. O nome do banco de dados é: "$DATABASE_NAME$". Importando schema agora...';
$locale['step_database_config_saved'] = 'A configuração local foi salva no arquivo: config.local.php';
$locale['step_database_error_path'] = 'Por favor, especifique o caminho da pasta do servidor.';
$locale['step_database_error_config'] = 'Não é possível encontrar o arquivo config.lua. O caminho da pasta do seu servidor está correto? Volte e verifique novamente.';
$locale['step_database_error_database_empty'] = 'Não é possível determinar o tipo de banco de dados a partir do config.lua. Seu OTS não é suportado por este AAC.';
$locale['step_database_error_only_mysql'] = 'Este AAC suporta apenas o MySQL. A partir do seu arquivo de configuração, parece que o seu OTS está usando: $DATABASE_TYPE$ database. Por favor, mude seu banco de dados para o MySQL e siga a instalação novamente.';
$locale['step_database_error_table'] = 'A tabela $TABLE$ não existe. Por favor, importe seu schema de banco de dados OTS primeiro.';
$locale['step_database_error_table_exist'] = 'A tabela $TABLE$ já existe. Parece que o AAC já está instalado. Ignorando importando o schema MySQL.';
$locale['step_database_error_mysql_connect'] = 'Não é possível conectar-se ao banco de dados MySQL.';
$locale['step_database_error_mysql_connect_2'] = 'Razões possíveis:';
$locale['step_database_error_mysql_connect_3'] = 'O MySQL não está configurado adequadamente em <i>config.lua</i>.';
$locale['step_database_error_mysql_connect_4'] = 'O servidor MySQL não está em execução.';
$locale['step_database_error_schema'] = 'Erro ao importar schema:';
$locale['step_database_success_schema'] = 'Tabelas $PREFIX$ instaladas com sucesso.';
$locale['step_database_error_file'] = '$FILE$ não pôde ser aberto. Por favor, copie este conteúdo e cole no arquivo:';
$locale['step_database_adding_field'] = 'Adicionando campo';
$locale['step_database_modifying_field'] = 'Modificando campo';
$locale['step_database_changing_field'] = 'Alterarando $FIELD$ para $FIELD_NEW$...';
$locale['step_database_imported_players'] = 'Player samples foram importadas...';
$locale['step_database_loaded_items'] = 'Items foram carregados...';
$locale['step_database_loaded_weapons'] = 'Weapons foram carregadas...';
$locale['step_database_loaded_monsters'] = 'Monsters foram carregados...';
$locale['step_database_error_monsters'] = 'Houve alguns problemas ao carregar seu arquivo monsters.xml. Por favor, verifique $LOG$ para mais informações.';
$locale['step_database_loaded_spells'] = 'Spells foram carregadas...';
$locale['step_database_created_account'] = 'Conta de administrador criada...';
$locale['step_database_created_news'] = 'Notícias foram criadas...';

// admin account
$locale['step_admin'] = 'Conta Administrador';
$locale['step_admin_title'] = 'Criar conta de administrador';
$locale['step_admin_email'] = 'E-mail do administrador';
$locale['step_admin_email_desc'] = 'E-mail da sua conta de administrador, que pode ser usado para redefinir a senha.';
$locale['step_admin_email_error_empty'] = 'Por favor, insira o endereço de e-mail da sua nova conta.';
$locale['step_admin_email_error_format'] = 'Formato de email inválido.';
$locale['step_admin_account'] = 'Nome da conta de administrador';
$locale['step_admin_account_desc'] = 'Nome da sua conta de administrador, que será usada para acessar o site e o servidor.';
$locale['step_admin_account_error_empty'] = 'Por favor, insira o nome da conta.';
$locale['step_admin_account_error_format'] = 'Formato de nome de conta inválido. Use apenas a-Z e números de 0 a 9. Mínimo 3, máximo 32 caracteres.';
$locale['step_admin_account_error_same'] = 'A senha pode não ser o mesmo que o nome da conta.';
$locale['step_admin_account_id'] = 'Número da conta de administrador';
$locale['step_admin_account_id_desc'] = 'Número da sua conta de administrador, que será usada para acessar o site e o servidor.';
$locale['step_admin_account_id_error_empty'] = 'Por favor, insira o número da conta.';
$locale['step_admin_account_id_error_format'] = 'Formato de número de conta inválido. Por favor, use apenas números 0-9. Mínimo 6, máximo 10 caracteres.';
$locale['step_admin_account_id_error_same'] = 'A senha pode não ser o mesmo que o número da conta.';
$locale['step_admin_password'] = 'Senha da conta de administrador';
$locale['step_admin_password_desc'] = 'Senha para sua conta de administrador.';
$locale['step_admin_password_error_empty'] = 'Por favor, digite a senha da sua nova conta.';
$locale['step_admin_password_error_format'] = 'Formato de senha inválido. Use apenas a-Z e números de 0 a 9. Mínimo 8, máximo 30 caracteres.';
$locale['step_admin_player_name'] = 'Nome do personagem Administrador';
$locale['step_admin_player_name_desc'] = 'Nome do seu personagem Administrador';
$locale['step_admin_player_name_error_empty'] = 'Por favor, digite o nome do seu personagem.';
$locale['step_admin_player_name_error_format'] = 'Formato de nome de jogador inválido. Use apenas A-Z, espaços e \'. Mínimo 3, máximo 25 caracteres.';

// finish
$locale['step_finish_admin_panel'] = 'Painel de administração';
$locale['step_finish_homepage'] = 'pagina inicial';
$locale['step_finish'] = 'Finalizar';
$locale['step_finish_title'] = 'Instalação terminada!';
$locale['step_finish_desc'] = 'Parabéns! <b>MyAAC</b> está pronto para uso!<br/>Agora você pode fazer login em $ADMIN_PANEL$ ou visitar $HOMEPAGE$.<br/><br/>
<span style = "color: red">Por favor remova a pasta install/.</span><br/><br/>Postar bugs e sugestões em $LINK$, obrigado!';
?>
