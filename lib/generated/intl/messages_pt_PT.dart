// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt_PT locale. All the
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
  String get localeName => 'pt_PT';

  static String m0(selectListLength, maxSelect) =>
      "${selectListLength}${maxSelect}Determinar ( / )";

  static String m1(error) => "\n\n ${error}Falha na criação";

  static String m2(days) => "${days}dias atrás";

  static String m3(thing) => "${thing}Pretende eliminar \" \"?";

  static String m4(name) =>
      "${name}Pretende apagar o ficheiro \" \"? As mensagens com este ficheiro anexado também serão eliminadas.";

  static String m5(name) =>
      "${name}Pretende apagar a pasta \" \"? Se houver conteúdos na pasta, elimine primeiro os conteúdos da pasta.";

  static String m6(day, hour, minute, second) =>
      "${day}${hour}${minute}${second}Dias horas minutos segundos";

  static String m7(hour, minute, second) =>
      "${hour}${minute}${second}Horas Minutos Segundos";

  static String m8(minute, second) => "${minute}${second}Minutos segundos";

  static String m9(second) =>
      "${second}unidade de ângulo ou arco equivalente a um sexagésimo de grau";

  static String m10(error) => "\n\n${error}Falha no envio do correio";

  static String m11(hours) => "${hours}horas atrás";

  static String m12(server) => "${server}Atualmente com sessão iniciada";

  static String m13(minutes) => "${minutes}minutos atrás";

  static String m14(months) => "${months}meses atrás";

  static String m15(language) => "${language} \nTraduzir de para";

  static String m16(type) => "${type}Tipos de notificação não suportados:";

  static String m17(seconds) => "${seconds}segundos atrás";

  static String m18(msg) => "\n ${msg}A transferência falhou";

  static String m19(count) => "${count}Total de votos";

  static String m20(count) => "${count}pessoa detida para resgate";

  static String m21(index) => "${index}Opções";

  static String m22(index) => "${index}A opção não pode estar vazia";

  static String m23(datetime) => "${datetime}prazo pós-conclusão";

  static String m24(years) => "${years}...anos atrás";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "account": MessageLookupByLibrary.simpleMessage("nome de utilizador"),
        "add": MessageLookupByLibrary.simpleMessage("aumentar"),
        "addAccount": MessageLookupByLibrary.simpleMessage("Adicionar conta"),
        "addFile": MessageLookupByLibrary.simpleMessage("Adicionar ficheiro"),
        "addTitle": MessageLookupByLibrary.simpleMessage("Adicionar título"),
        "all": MessageLookupByLibrary.simpleMessage("completo"),
        "announcementActive":
            MessageLookupByLibrary.simpleMessage("Anúncio agora"),
        "announcementExpired":
            MessageLookupByLibrary.simpleMessage("Anúncios anteriores"),
        "announcements": MessageLookupByLibrary.simpleMessage("boletim"),
        "back": MessageLookupByLibrary.simpleMessage("voltar (ou ir)"),
        "cancel": MessageLookupByLibrary.simpleMessage("cancelamentos"),
        "cancelSensitive": MessageLookupByLibrary.simpleMessage(
            "Retirar a marcação de conteúdos sensíveis"),
        "clip": MessageLookupByLibrary.simpleMessage("memorando"),
        "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
            "Tem a certeza de que quer cancelar a coleção?"),
        "clipCreate":
            MessageLookupByLibrary.simpleMessage("Novas notas adesivas"),
        "clipFavorite":
            MessageLookupByLibrary.simpleMessage("Adicionar aos favoritos"),
        "clipFavoriteList":
            MessageLookupByLibrary.simpleMessage("marcador (Internet)"),
        "clipRemove":
            MessageLookupByLibrary.simpleMessage("Remover notas adesivas"),
        "clips": MessageLookupByLibrary.simpleMessage("memorando"),
        "confirmSelection": m0,
        "copyContent": MessageLookupByLibrary.simpleMessage("Copiar conteúdo"),
        "copyLink": MessageLookupByLibrary.simpleMessage("Copiar ligação"),
        "copyRSS": MessageLookupByLibrary.simpleMessage("Copiar RSS"),
        "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
            "Copiar o endereço da página inicial do utilizador"),
        "copyUsername":
            MessageLookupByLibrary.simpleMessage("Copiar nome de utilizador"),
        "createFolder": MessageLookupByLibrary.simpleMessage("Nova pasta"),
        "createNote":
            MessageLookupByLibrary.simpleMessage("Publicar um novo tópico"),
        "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
            "Criar posts a partir de ficheiros"),
        "createNoteHint":
            MessageLookupByLibrary.simpleMessage("O que aconteceu..."),
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
        "download": MessageLookupByLibrary.simpleMessage("descarregamento"),
        "drive": MessageLookupByLibrary.simpleMessage(
            "armazenamento de ficheiros na nuvem"),
        "durationDay": m6,
        "durationHour": m7,
        "durationMinute": m8,
        "durationSecond": m9,
        "edit": MessageLookupByLibrary.simpleMessage("compilador"),
        "emoji": MessageLookupByLibrary.simpleMessage("emoticon"),
        "enterNewFileName": MessageLookupByLibrary.simpleMessage(
            "Introduzir um novo nome de ficheiro"),
        "enterNewTitle":
            MessageLookupByLibrary.simpleMessage("Introduzir um novo título"),
        "enterUrl": MessageLookupByLibrary.simpleMessage("Introduzir o URL"),
        "exceptionContentNull": MessageLookupByLibrary.simpleMessage(
            "O conteúdo não pode estar vazio"),
        "exceptionCwNull": MessageLookupByLibrary.simpleMessage(
            "O conteúdo não pode estar vazio"),
        "exceptionSendNote": m10,
        "explore": MessageLookupByLibrary.simpleMessage("descobertas"),
        "exploreHot": MessageLookupByLibrary.simpleMessage("em voga"),
        "exploreUserHot":
            MessageLookupByLibrary.simpleMessage("utilizador popular"),
        "exploreUserLast": MessageLookupByLibrary.simpleMessage(
            "Utilizadores recentemente iniciados"),
        "exploreUserPined":
            MessageLookupByLibrary.simpleMessage("utilizador no topo da lista"),
        "exploreUserUpdated":
            MessageLookupByLibrary.simpleMessage("Colaboradores recentes"),
        "exploreUsers": MessageLookupByLibrary.simpleMessage("utilizador"),
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
        "inputServer":
            MessageLookupByLibrary.simpleMessage("Servidor de entrada manual"),
        "insertDriverFile":
            MessageLookupByLibrary.simpleMessage("Inserção de acessórios"),
        "isFollowingYouNow":
            MessageLookupByLibrary.simpleMessage("Estou a observar-te."),
        "justNow": MessageLookupByLibrary.simpleMessage("há pouco tempo"),
        "keepOriginal":
            MessageLookupByLibrary.simpleMessage("Preservar a imagem original"),
        "loadingServers":
            MessageLookupByLibrary.simpleMessage("Server Loading"),
        "local": MessageLookupByLibrary.simpleMessage("esta localidade"),
        "localUpload":
            MessageLookupByLibrary.simpleMessage("carregamento local"),
        "login": MessageLookupByLibrary.simpleMessage("iniciar sessão"),
        "loginFailed": MessageLookupByLibrary.simpleMessage("Falha no login"),
        "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
            "Falha no início de sessão: Falha na criação da aplicação"),
        "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
            "Falha no login: a aquisição do token falhou"),
        "loginLoading": m12,
        "loginSuccess": MessageLookupByLibrary.simpleMessage(
            "Início de sessão bem sucedido"),
        "manageAccount": MessageLookupByLibrary.simpleMessage("Gerir conta"),
        "markAsSensitive": MessageLookupByLibrary.simpleMessage(
            "Assinalar como conteúdo sensível"),
        "mention": MessageLookupByLibrary.simpleMessage("criar (um assunto)"),
        "minute": MessageLookupByLibrary.simpleMessage("minutos"),
        "minutesAgo": m13,
        "monthsAgo": m14,
        "more": MessageLookupByLibrary.simpleMessage("mais"),
        "myCLips": MessageLookupByLibrary.simpleMessage("A minha nota."),
        "name": MessageLookupByLibrary.simpleMessage("nome (de uma coisa)"),
        "nameCannotBeEmpty":
            MessageLookupByLibrary.simpleMessage("O nome não pode estar vazio"),
        "next": MessageLookupByLibrary.simpleMessage("o próximo passo"),
        "noLists":
            MessageLookupByLibrary.simpleMessage("You don\'t have any lists"),
        "notFindServer": MessageLookupByLibrary.simpleMessage(
            "Não encontrou o seu servidor?"),
        "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
            "Copiar a ligação para este sítio"),
        "noteCwHide": MessageLookupByLibrary.simpleMessage("guardar"),
        "noteCwShow": MessageLookupByLibrary.simpleMessage("Exibir conteúdo"),
        "noteFormLanguageTranslation": m15,
        "noteLocalOnly": MessageLookupByLibrary.simpleMessage(
            "Não participação em acções conjuntas"),
        "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
            "Aceder ao servidor anfitrião para visualizar"),
        "notePined": MessageLookupByLibrary.simpleMessage("Top Posts"),
        "noteQuote": MessageLookupByLibrary.simpleMessage("citação"),
        "noteReNote": MessageLookupByLibrary.simpleMessage(
            "reencaminhamento (correio, SMS, pacotes de dados)"),
        "noteReNoteByUser":
            MessageLookupByLibrary.simpleMessage("Encaminhado."),
        "noteTranslate":
            MessageLookupByLibrary.simpleMessage("Tradução de mensagens"),
        "noteVisibility": MessageLookupByLibrary.simpleMessage("visibilidade"),
        "noteVisibilityFollowers":
            MessageLookupByLibrary.simpleMessage("observador"),
        "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
            "Enviar apenas aos seguidores"),
        "noteVisibilityHome":
            MessageLookupByLibrary.simpleMessage("fig. início"),
        "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
            "Linha de tempo enviada apenas para a página inicial"),
        "noteVisibilityPublic":
            MessageLookupByLibrary.simpleMessage("abertamente"),
        "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
            "A sua publicação aparecerá na linha de tempo global"),
        "noteVisibilitySpecified":
            MessageLookupByLibrary.simpleMessage("carta privada"),
        "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
            "Enviar apenas para utilizadores especificados"),
        "notes": MessageLookupByLibrary.simpleMessage("cartão"),
        "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
        "notification": MessageLookupByLibrary.simpleMessage("notificações"),
        "notifications": MessageLookupByLibrary.simpleMessage("notificações"),
        "notifyAll": MessageLookupByLibrary.simpleMessage("completo"),
        "notifyFilter": MessageLookupByLibrary.simpleMessage("rastreio"),
        "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
            "O seu pedido de atenção foi aprovado."),
        "notifyFollowedYou":
            MessageLookupByLibrary.simpleMessage("Tem novos seguidores."),
        "notifyMarkAllRead":
            MessageLookupByLibrary.simpleMessage("Marcar tudo como lido"),
        "notifyMention":
            MessageLookupByLibrary.simpleMessage("A propósito do meu"),
        "notifyMessage": MessageLookupByLibrary.simpleMessage("carta privada"),
        "notifyNotSupport": m16,
        "ok": MessageLookupByLibrary.simpleMessage("definir"),
        "openInNewTab":
            MessageLookupByLibrary.simpleMessage("Ir para o ecrã do navegador"),
        "overviews": MessageLookupByLibrary.simpleMessage("passar por cima"),
        "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
            "Preocupações com a concessão dos pedidos"),
        "preview": MessageLookupByLibrary.simpleMessage("antevisões"),
        "previewNote":
            MessageLookupByLibrary.simpleMessage("Pré-visualizar mensagens"),
        "processing": MessageLookupByLibrary.simpleMessage("em curso"),
        "public": MessageLookupByLibrary.simpleMessage("abertamente"),
        "publish": MessageLookupByLibrary.simpleMessage("posto"),
        "reNoteHint":
            MessageLookupByLibrary.simpleMessage("Citando este post..."),
        "reNoteText": MessageLookupByLibrary.simpleMessage("Citar o post"),
        "reaction": MessageLookupByLibrary.simpleMessage("resposta"),
        "reactionAccepting":
            MessageLookupByLibrary.simpleMessage("Aceitar respostas de emojis"),
        "reactionAcceptingAll":
            MessageLookupByLibrary.simpleMessage("completo"),
        "reactionAcceptingLikeOnly":
            MessageLookupByLibrary.simpleMessage("Apenas gostos"),
        "reactionAcceptingLikeOnlyRemote":
            MessageLookupByLibrary.simpleMessage("Apenas Kudos Remotos"),
        "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
            "Apenas conteúdos não sensíveis"),
        "reactionAcceptingNoneSensitiveOrLocal":
            MessageLookupByLibrary.simpleMessage(
                "Apenas conteúdos não sensíveis (apenas gostos remotos)"),
        "recipient": MessageLookupByLibrary.simpleMessage(
            "Para: (cabeçalho do correio eletrónico)"),
        "refresh": MessageLookupByLibrary.simpleMessage(
            "atualizar (janela do computador)"),
        "registration": MessageLookupByLibrary.simpleMessage("Registration"),
        "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
        "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
        "remote": MessageLookupByLibrary.simpleMessage("remotamente"),
        "rename": MessageLookupByLibrary.simpleMessage("renomear"),
        "renameFile":
            MessageLookupByLibrary.simpleMessage("Mudar o nome do ficheiro"),
        "renameFolder":
            MessageLookupByLibrary.simpleMessage("Mudar o nome de uma pasta"),
        "replyNoteHint":
            MessageLookupByLibrary.simpleMessage("Responder a este post..."),
        "replyNoteText":
            MessageLookupByLibrary.simpleMessage("Responder a uma mensagem"),
        "saveFailed": MessageLookupByLibrary.simpleMessage("não salvar"),
        "saveImage": MessageLookupByLibrary.simpleMessage("Guardar imagem"),
        "saveSuccess":
            MessageLookupByLibrary.simpleMessage("Guardar com sucesso"),
        "search": MessageLookupByLibrary.simpleMessage("procurar algo"),
        "searchAll": MessageLookupByLibrary.simpleMessage("completo"),
        "searchHost": MessageLookupByLibrary.simpleMessage(
            "Especificar o nome de domínio"),
        "searchLocal": MessageLookupByLibrary.simpleMessage("este sítio"),
        "searchRemote": MessageLookupByLibrary.simpleMessage("remotamente"),
        "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
        "secondsAgo": m17,
        "selectHashtag":
            MessageLookupByLibrary.simpleMessage("Selecionar etiqueta"),
        "selectServer":
            MessageLookupByLibrary.simpleMessage("Please Select Your Server"),
        "selectUser":
            MessageLookupByLibrary.simpleMessage("Selecionar utilizador"),
        "sensitiveClickShow":
            MessageLookupByLibrary.simpleMessage("Clique para mostrar"),
        "sensitiveContent":
            MessageLookupByLibrary.simpleMessage("Conteúdo sensível"),
        "serverAddr":
            MessageLookupByLibrary.simpleMessage("endereço do servidor"),
        "serverList": MessageLookupByLibrary.simpleMessage("List of Servers"),
        "settings": MessageLookupByLibrary.simpleMessage("preparar"),
        "share": MessageLookupByLibrary.simpleMessage(
            "partilhar (alegrias, benefícios, privilégios, etc.) com os outros"),
        "showConversation": MessageLookupByLibrary.simpleMessage("Ver diálogo"),
        "somebodyNote": MessageLookupByLibrary.simpleMessage(" postos"),
        "timeline": MessageLookupByLibrary.simpleMessage("cronologia"),
        "timelineGlobal":
            MessageLookupByLibrary.simpleMessage("situação de segurança"),
        "timelineHome": MessageLookupByLibrary.simpleMessage("fig. início"),
        "timelineHybrid": MessageLookupByLibrary.simpleMessage("socialização"),
        "timelineLocal":
            MessageLookupByLibrary.simpleMessage("esta localidade"),
        "translate": MessageLookupByLibrary.simpleMessage("renderização"),
        "uncategorized":
            MessageLookupByLibrary.simpleMessage("Não categorizado"),
        "unfollow": MessageLookupByLibrary.simpleMessage("Deixar de seguir"),
        "updatedDate":
            MessageLookupByLibrary.simpleMessage("Data de atualização"),
        "uploadFailed": m18,
        "uploadFromUrl": MessageLookupByLibrary.simpleMessage(
            "Carregar a partir do sítio Web"),
        "user": MessageLookupByLibrary.simpleMessage("utilizador"),
        "userAll": MessageLookupByLibrary.simpleMessage("completo"),
        "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
            "Este utilizador ainda não se apresentou"),
        "userFile":
            MessageLookupByLibrary.simpleMessage("anexo (correio eletrónico)"),
        "userHot": MessageLookupByLibrary.simpleMessage("utilizador"),
        "userNote": MessageLookupByLibrary.simpleMessage("cartão"),
        "userRegisterBy": MessageLookupByLibrary.simpleMessage("registado em"),
        "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
            "Lista de widgets (inacabada)"),
        "username": MessageLookupByLibrary.simpleMessage("ID do utilizador"),
        "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
        "video": MessageLookupByLibrary.simpleMessage("vídeo"),
        "view": MessageLookupByLibrary.simpleMessage("verificar"),
        "viewMore": MessageLookupByLibrary.simpleMessage("Ver mais"),
        "vote": MessageLookupByLibrary.simpleMessage("referendo"),
        "voteAllCount": m19,
        "voteCount": m20,
        "voteDueDate": MessageLookupByLibrary.simpleMessage("data-limite"),
        "voteEnableMultiChoice":
            MessageLookupByLibrary.simpleMessage("Votos múltiplos permitidos"),
        "voteExpired":
            MessageLookupByLibrary.simpleMessage("A votação está encerrada."),
        "voteNoDueDate":
            MessageLookupByLibrary.simpleMessage("permanentemente"),
        "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
            "O número de votos não pode ser inferior a dois"),
        "voteOptionHint": m21,
        "voteOptionNullIndex": m22,
        "voteResult": MessageLookupByLibrary.simpleMessage(
            "Os resultados da votação foram gerados"),
        "voteWillExpired": m23,
        "yearsAgo": m24
      };
}
