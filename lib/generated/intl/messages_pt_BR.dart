// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt_BR locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'pt_BR';

  static String m0(selectListLength, maxSelect) =>
      "${selectListLength}${maxSelect}Determinar ( / )";

  static String m1(error) => "\n\n ${error}Falha na criação";

  static String m2(days) => "${days}dias atrás";

  static String m3(thing) => "${thing}Deseja excluir \" \"?";

  static String m4(name) =>
      "${name}Deseja excluir o arquivo \" \"? As postagens com esse arquivo anexado também serão excluídas.";

  static String m5(name) =>
      "${name}Deseja excluir a pasta \" \"? Se houver conteúdo na pasta, exclua o conteúdo da pasta primeiro.";

  static String m6(day, hour, minute, second) =>
      "${day}${hour}${minute}${second}Dias horas minutos segundos";

  static String m7(hour, minute, second) =>
      "${hour}${minute}${second}Horas Minutos Segundos";

  static String m8(minute, second) => "${minute}${second}Minutos segundos";

  static String m9(second) =>
      "${second}unidade de ângulo ou arco equivalente a um sexagésimo de um grau";

  static String m10(error) => "\n\n${error}Falha ao enviar a postagem";

  static String m11(hours) => "${hours}horas atrás";

  static String m12(server) => "${server}Atualmente conectado";

  static String m13(minutes) => "${minutes}minutos atrás";

  static String m14(months) => "${months}meses atrás";

  static String m15(language) => "${language} \nTraduzir de para";

  static String m16(type) => "${type}Tipos de notificação sem suporte:";

  static String m17(seconds) => "${seconds}segundos atrás";

  static String m18(msg) => "\n ${msg}Falha no upload";

  static String m19(count) => "${count}Total de votos";

  static String m20(count) => "${count}pessoa mantida para resgate";

  static String m21(index) => "${index}Opções";

  static String m22(index) => "${index}A opção não pode estar vazia";

  static String m23(datetime) => "${datetime}prazo pós-conclusão";

  static String m24(years) => "${years}...anos atrás";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "account": MessageLookupByLibrary.simpleMessage("nome de usuário"),
    "add": MessageLookupByLibrary.simpleMessage("aumentar"),
    "addAccount": MessageLookupByLibrary.simpleMessage("Adicionar conta"),
    "addFile": MessageLookupByLibrary.simpleMessage("Adicionar arquivo"),
    "addTitle": MessageLookupByLibrary.simpleMessage("Adicionar título"),
    "all": MessageLookupByLibrary.simpleMessage("completo"),
    "announcementActive": MessageLookupByLibrary.simpleMessage("Anúncio agora"),
    "announcementExpired": MessageLookupByLibrary.simpleMessage(
      "Anúncios anteriores",
    ),
    "announcements": MessageLookupByLibrary.simpleMessage("boletim"),
    "back": MessageLookupByLibrary.simpleMessage("voltar (ou ir)"),
    "cancel": MessageLookupByLibrary.simpleMessage("cancelamentos"),
    "cancelSensitive": MessageLookupByLibrary.simpleMessage(
      "Desfazer a marcação de conteúdo sensível",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clip": MessageLookupByLibrary.simpleMessage("memorando"),
    "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
      "Tem certeza de que deseja cancelar a cobrança?",
    ),
    "clipCreate": MessageLookupByLibrary.simpleMessage("Novas notas adesivas"),
    "clipFavorite": MessageLookupByLibrary.simpleMessage(
      "Adicionar aos favoritos",
    ),
    "clipFavoriteList": MessageLookupByLibrary.simpleMessage(
      "marcador (Internet)",
    ),
    "clipRemove": MessageLookupByLibrary.simpleMessage(
      "Remover notas adesivas",
    ),
    "clipUpdate": MessageLookupByLibrary.simpleMessage(
      "Atualizar notas adesivas",
    ),
    "clips": MessageLookupByLibrary.simpleMessage("memorando"),
    "close": MessageLookupByLibrary.simpleMessage("关闭"),
    "confirmSelection": m0,
    "copyContent": MessageLookupByLibrary.simpleMessage("Copiar conteúdo"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Copiar link"),
    "copyRSS": MessageLookupByLibrary.simpleMessage("Copiar RSS"),
    "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
      "Copie o endereço da página inicial do usuário",
    ),
    "copyUsername": MessageLookupByLibrary.simpleMessage(
      "Copiar nome de usuário",
    ),
    "createFolder": MessageLookupByLibrary.simpleMessage("Nova pasta"),
    "createNote": MessageLookupByLibrary.simpleMessage(
      "Publicar um novo tópico",
    ),
    "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
      "Criação de uma postagem a partir de um arquivo",
    ),
    "createNoteHint": MessageLookupByLibrary.simpleMessage(
      "O que aconteceu...",
    ),
    "createdDate": MessageLookupByLibrary.simpleMessage("Data de criação"),
    "creationFailedDialog": m1,
    "cw": MessageLookupByLibrary.simpleMessage("conteúdo oculto"),
    "day": MessageLookupByLibrary.simpleMessage("dia"),
    "daysAgo": m2,
    "delete": MessageLookupByLibrary.simpleMessage("remoção"),
    "deleteConfirm": m3,
    "deleteFileConfirmation": m4,
    "deleteFolderConfirmation": m5,
    "description": MessageLookupByLibrary.simpleMessage("descrições"),
    "done": MessageLookupByLibrary.simpleMessage("cumprir"),
    "download": MessageLookupByLibrary.simpleMessage("download"),
    "drive": MessageLookupByLibrary.simpleMessage(
      "armazenamento de arquivos na nuvem",
    ),
    "durationDay": m6,
    "durationHour": m7,
    "durationMinute": m8,
    "durationSecond": m9,
    "edit": MessageLookupByLibrary.simpleMessage("compilador"),
    "emoji": MessageLookupByLibrary.simpleMessage("emoticon"),
    "enterNewFileName": MessageLookupByLibrary.simpleMessage(
      "Digite um novo nome de arquivo",
    ),
    "enterNewTitle": MessageLookupByLibrary.simpleMessage(
      "Digite um novo título",
    ),
    "enterUrl": MessageLookupByLibrary.simpleMessage("Digite o URL"),
    "exceptionContentNull": MessageLookupByLibrary.simpleMessage(
      "O conteúdo não pode estar vazio",
    ),
    "exceptionCwNull": MessageLookupByLibrary.simpleMessage(
      "O conteúdo não pode estar vazio",
    ),
    "exceptionSendNote": m10,
    "explore": MessageLookupByLibrary.simpleMessage("descobertas"),
    "exploreHot": MessageLookupByLibrary.simpleMessage("em voga"),
    "exploreUserHot": MessageLookupByLibrary.simpleMessage("usuário popular"),
    "exploreUserLast": MessageLookupByLibrary.simpleMessage(
      "Usuários conectados recentemente",
    ),
    "exploreUserPined": MessageLookupByLibrary.simpleMessage(
      "usuário no topo da lista",
    ),
    "exploreUserUpdated": MessageLookupByLibrary.simpleMessage(
      "Colaboradores recentes",
    ),
    "exploreUsers": MessageLookupByLibrary.simpleMessage("usuário"),
    "favorite": MessageLookupByLibrary.simpleMessage("marcador (Internet)"),
    "filter": MessageLookupByLibrary.simpleMessage("Filter"),
    "folderName": MessageLookupByLibrary.simpleMessage("Nome da pasta"),
    "follow": MessageLookupByLibrary.simpleMessage("foco"),
    "followed": MessageLookupByLibrary.simpleMessage("Seguido"),
    "followers": MessageLookupByLibrary.simpleMessage("observador"),
    "following": MessageLookupByLibrary.simpleMessage("Preocupado"),
    "fromCloud": MessageLookupByLibrary.simpleMessage("Do netbook"),
    "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
    "hashtag": MessageLookupByLibrary.simpleMessage("hashtag"),
    "hostnames": MessageLookupByLibrary.simpleMessage("nome de domínio"),
    "hour": MessageLookupByLibrary.simpleMessage("horas"),
    "hoursAgo": m11,
    "image": MessageLookupByLibrary.simpleMessage("fotografia"),
    "inputServer": MessageLookupByLibrary.simpleMessage(
      "Servidor de entrada manual",
    ),
    "insertDriverFile": MessageLookupByLibrary.simpleMessage(
      "Inserção de acessórios",
    ),
    "isFollowingYouNow": MessageLookupByLibrary.simpleMessage(
      "Estou de olho em você.",
    ),
    "justNow": MessageLookupByLibrary.simpleMessage("recentemente"),
    "keepOriginal": MessageLookupByLibrary.simpleMessage(
      "Preservar a imagem original",
    ),
    "loadingServers": MessageLookupByLibrary.simpleMessage("Server Loading"),
    "local": MessageLookupByLibrary.simpleMessage("esta localidade"),
    "localUpload": MessageLookupByLibrary.simpleMessage("upload local"),
    "login": MessageLookupByLibrary.simpleMessage("fazer login"),
    "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
    "loginFailed": MessageLookupByLibrary.simpleMessage("Falha no login"),
    "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
      "Falha no login: falha na criação do aplicativo",
    ),
    "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
      "Falha no login: falha na aquisição do token",
    ),
    "loginLoading": m12,
    "loginSuccess": MessageLookupByLibrary.simpleMessage("Login bem-sucedido"),
    "manageAccount": MessageLookupByLibrary.simpleMessage("Gerenciar conta"),
    "markAsSensitive": MessageLookupByLibrary.simpleMessage(
      "Sinalizar como conteúdo sensível",
    ),
    "mention": MessageLookupByLibrary.simpleMessage("criar (um assunto)"),
    "minute": MessageLookupByLibrary.simpleMessage("minutos"),
    "minutesAgo": m13,
    "monthsAgo": m14,
    "more": MessageLookupByLibrary.simpleMessage("mais"),
    "myCLips": MessageLookupByLibrary.simpleMessage("Minha observação."),
    "name": MessageLookupByLibrary.simpleMessage("nome (de uma coisa)"),
    "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "O nome não pode estar vazio",
    ),
    "next": MessageLookupByLibrary.simpleMessage("a próxima etapa"),
    "noLists": MessageLookupByLibrary.simpleMessage(
      "You don\'t have any lists",
    ),
    "notFindServer": MessageLookupByLibrary.simpleMessage(
      "Não encontrou seu servidor?",
    ),
    "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
      "Copie o link para este site",
    ),
    "noteCwHide": MessageLookupByLibrary.simpleMessage("guardar"),
    "noteCwShow": MessageLookupByLibrary.simpleMessage("Exibir conteúdo"),
    "noteFormLanguageTranslation": m15,
    "noteLocalOnly": MessageLookupByLibrary.simpleMessage(
      "Não participação em reuniões conjuntas",
    ),
    "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
      "Vá para o servidor host para exibir",
    ),
    "notePined": MessageLookupByLibrary.simpleMessage("Principais publicações"),
    "noteQuote": MessageLookupByLibrary.simpleMessage("citação"),
    "noteReNote": MessageLookupByLibrary.simpleMessage(
      "encaminhamento (correio eletrônico, SMS, pacotes de dados)",
    ),
    "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("Encaminhado."),
    "noteTranslate": MessageLookupByLibrary.simpleMessage(
      "Tradução de postagens",
    ),
    "noteVisibility": MessageLookupByLibrary.simpleMessage("visibilidade"),
    "noteVisibilityFollowers": MessageLookupByLibrary.simpleMessage(
      "observador",
    ),
    "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
      "Enviar somente para seguidores",
    ),
    "noteVisibilityHome": MessageLookupByLibrary.simpleMessage("fig. início"),
    "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
      "Linha do tempo enviada apenas para a página inicial",
    ),
    "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage("abertamente"),
    "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
      "Sua publicação aparecerá na linha do tempo global",
    ),
    "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage(
      "carta particular",
    ),
    "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
      "Enviar apenas para usuários especificados",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("cartão"),
    "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
    "notification": MessageLookupByLibrary.simpleMessage("notificações"),
    "notifications": MessageLookupByLibrary.simpleMessage("notificações"),
    "notifyAll": MessageLookupByLibrary.simpleMessage("completo"),
    "notifyFilter": MessageLookupByLibrary.simpleMessage("triagem"),
    "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
      "Sua solicitação de atenção foi aprovada.",
    ),
    "notifyFollowedYou": MessageLookupByLibrary.simpleMessage(
      "Você tem novos seguidores.",
    ),
    "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage(
      "Marcar tudo como lido",
    ),
    "notifyMention": MessageLookupByLibrary.simpleMessage("Falando de minha"),
    "notifyMessage": MessageLookupByLibrary.simpleMessage("carta particular"),
    "notifyNotSupport": m16,
    "ok": MessageLookupByLibrary.simpleMessage("definir"),
    "openInNewTab": MessageLookupByLibrary.simpleMessage(
      "Ir para a exibição do navegador",
    ),
    "overviews": MessageLookupByLibrary.simpleMessage("passar por cima"),
    "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
      "Preocupações com a concessão de solicitações",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("visualizações"),
    "previewNote": MessageLookupByLibrary.simpleMessage(
      "Posts de visualização",
    ),
    "processing": MessageLookupByLibrary.simpleMessage("em andamento"),
    "public": MessageLookupByLibrary.simpleMessage("abertamente"),
    "publish": MessageLookupByLibrary.simpleMessage("postagem"),
    "reNoteHint": MessageLookupByLibrary.simpleMessage(
      "Citando esta postagem...",
    ),
    "reNoteText": MessageLookupByLibrary.simpleMessage("Citar postagem"),
    "reaction": MessageLookupByLibrary.simpleMessage("resposta"),
    "reactionAccepting": MessageLookupByLibrary.simpleMessage(
      "Aceitando respostas de emojis",
    ),
    "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("completo"),
    "reactionAcceptingLikeOnly": MessageLookupByLibrary.simpleMessage(
      "Apenas gostos",
    ),
    "reactionAcceptingLikeOnlyRemote": MessageLookupByLibrary.simpleMessage(
      "Somente Kudos Remotos",
    ),
    "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
      "Somente conteúdo não sensível",
    ),
    "reactionAcceptingNoneSensitiveOrLocal":
        MessageLookupByLibrary.simpleMessage(
          "Somente conteúdo não sensível (somente curtidas remotas)",
        ),
    "recipient": MessageLookupByLibrary.simpleMessage(
      "Para: (cabeçalho do e-mail)",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage(
      "atualizar (janela do computador)",
    ),
    "registration": MessageLookupByLibrary.simpleMessage("Registration"),
    "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
    "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
    "remote": MessageLookupByLibrary.simpleMessage("remotamente"),
    "rename": MessageLookupByLibrary.simpleMessage("renomear"),
    "renameFile": MessageLookupByLibrary.simpleMessage("Renomear o arquivo"),
    "renameFolder": MessageLookupByLibrary.simpleMessage("Renomear uma pasta"),
    "replyNoteHint": MessageLookupByLibrary.simpleMessage(
      "Responder a esta postagem...",
    ),
    "replyNoteText": MessageLookupByLibrary.simpleMessage(
      "Responder a uma postagem",
    ),
    "saveFailed": MessageLookupByLibrary.simpleMessage("não conseguir salvar"),
    "saveImage": MessageLookupByLibrary.simpleMessage("Salvar imagem"),
    "saveSuccess": MessageLookupByLibrary.simpleMessage("Salvar com sucesso"),
    "search": MessageLookupByLibrary.simpleMessage("procurar algo"),
    "searchAll": MessageLookupByLibrary.simpleMessage("completo"),
    "searchHost": MessageLookupByLibrary.simpleMessage(
      "Especificar o nome do domínio",
    ),
    "searchLocal": MessageLookupByLibrary.simpleMessage("este site"),
    "searchRemote": MessageLookupByLibrary.simpleMessage("remotamente"),
    "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
    "secondsAgo": m17,
    "selectHashtag": MessageLookupByLibrary.simpleMessage(
      "Selecionar etiqueta",
    ),
    "selectServer": MessageLookupByLibrary.simpleMessage(
      "Please Select Your Server",
    ),
    "selectUser": MessageLookupByLibrary.simpleMessage("Selecionar usuário"),
    "sensitiveClickShow": MessageLookupByLibrary.simpleMessage(
      "Clique para mostrar",
    ),
    "sensitiveContent": MessageLookupByLibrary.simpleMessage(
      "Conteúdo sensível",
    ),
    "serverAddr": MessageLookupByLibrary.simpleMessage("endereço do servidor"),
    "serverList": MessageLookupByLibrary.simpleMessage("List of Servers"),
    "settings": MessageLookupByLibrary.simpleMessage("configurar"),
    "share": MessageLookupByLibrary.simpleMessage(
      "compartilhar (alegrias, benefícios, privilégios etc.) com outras pessoas",
    ),
    "showConversation": MessageLookupByLibrary.simpleMessage("Ver diálogo"),
    "somebodyNote": MessageLookupByLibrary.simpleMessage(" postagens"),
    "timeline": MessageLookupByLibrary.simpleMessage("linha do tempo"),
    "timelineGlobal": MessageLookupByLibrary.simpleMessage(
      "situação de segurança",
    ),
    "timelineHome": MessageLookupByLibrary.simpleMessage("fig. início"),
    "timelineHybrid": MessageLookupByLibrary.simpleMessage("socialização"),
    "timelineLocal": MessageLookupByLibrary.simpleMessage("esta localidade"),
    "translate": MessageLookupByLibrary.simpleMessage("renderização"),
    "uncategorized": MessageLookupByLibrary.simpleMessage("Não categorizado"),
    "unfollow": MessageLookupByLibrary.simpleMessage("Deixar de seguir"),
    "updatedDate": MessageLookupByLibrary.simpleMessage("Data de atualização"),
    "uploadFailed": m18,
    "uploadFromUrl": MessageLookupByLibrary.simpleMessage(
      "Fazer upload do site",
    ),
    "user": MessageLookupByLibrary.simpleMessage("usuário"),
    "userAll": MessageLookupByLibrary.simpleMessage("completo"),
    "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
      "Este usuário ainda não se apresentou",
    ),
    "userFile": MessageLookupByLibrary.simpleMessage("anexo (e-mail)"),
    "userHot": MessageLookupByLibrary.simpleMessage("usuário"),
    "userNote": MessageLookupByLibrary.simpleMessage("cartão"),
    "userRegisterBy": MessageLookupByLibrary.simpleMessage("registrado em"),
    "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
      "Lista de widgets (inacabada)",
    ),
    "username": MessageLookupByLibrary.simpleMessage("ID do usuário"),
    "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
    "video": MessageLookupByLibrary.simpleMessage("vídeo"),
    "view": MessageLookupByLibrary.simpleMessage("confira"),
    "viewMore": MessageLookupByLibrary.simpleMessage("Veja mais"),
    "vote": MessageLookupByLibrary.simpleMessage("referendo"),
    "voteAllCount": m19,
    "voteCount": m20,
    "voteDueDate": MessageLookupByLibrary.simpleMessage("data-limite"),
    "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage(
      "Votos múltiplos permitidos",
    ),
    "voteExpired": MessageLookupByLibrary.simpleMessage(
      "A votação está encerrada.",
    ),
    "voteNoDueDate": MessageLookupByLibrary.simpleMessage("permanentemente"),
    "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
      "O número de votos não pode ser inferior a dois",
    ),
    "voteOptionHint": m21,
    "voteOptionNullIndex": m22,
    "voteResult": MessageLookupByLibrary.simpleMessage(
      "Os resultados da votação foram gerados",
    ),
    "voteWillExpired": m23,
    "yearsAgo": m24,
  };
}
