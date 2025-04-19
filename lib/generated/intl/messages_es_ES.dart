// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a es_ES locale. All the
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
  String get localeName => 'es_ES';

  static String m0(selectListLength, maxSelect) =>
      "${selectListLength}${maxSelect}Determinar ( / )";

  static String m1(error) => "\n\n ${error}Creación fallida";

  static String m2(days) => "${days}días atrás";

  static String m3(thing) => "${thing}¿Quieres borrar \" \"?";

  static String m4(name) =>
      "${name}¿Quieres borrar el archivo \" \"? Los mensajes que contengan este archivo también se eliminarán.";

  static String m5(name) =>
      "${name}¿Desea eliminar la carpeta \" \"? Si hay contenido en la carpeta, elimínelo primero.";

  static String m6(day, hour, minute, second) =>
      "${day}${hour}${minute}${second}Días horas minutos segundos";

  static String m7(hour, minute, second) =>
      "${hour}${minute}${second}Horas Minutos Segundos";

  static String m8(minute, second) => "${minute}${second}Minutos segundos";

  static String m9(second) =>
      "${second}unidad de ángulo o arco equivalente a la sexagésima parte de un grado";

  static String m10(error) => "\n\n${error}Error al enviar correo";

  static String m11(hours) => "${hours}hace horas";

  static String m12(server) => "${server}Actualmente conectado";

  static String m13(minutes) => "${minutes}hace minutos";

  static String m14(months) => "${months}hace meses";

  static String m15(language) => "${language} \nTraducir de a";

  static String m16(type) => "${type}Tipos de notificación no compatibles:";

  static String m17(seconds) => "${seconds}hace unos segundos";

  static String m18(msg) => "\n ${msg}Error de carga";

  static String m19(count) => "${count}Total de votos";

  static String m20(count) => "${count}persona secuestrada";

  static String m21(index) => "${index}Opciones";

  static String m22(index) => "${index}La opción no puede estar vacía";

  static String m23(datetime) => "${datetime}plazo posterior a la finalización";

  static String m24(years) => "${years}...hace años";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "account": MessageLookupByLibrary.simpleMessage("nombre de usuario"),
    "add": MessageLookupByLibrary.simpleMessage("aumentar"),
    "addAccount": MessageLookupByLibrary.simpleMessage("Añadir cuenta"),
    "addFile": MessageLookupByLibrary.simpleMessage("Añadir archivo"),
    "addTitle": MessageLookupByLibrary.simpleMessage("Añadir título"),
    "all": MessageLookupByLibrary.simpleMessage("completo"),
    "announcementActive": MessageLookupByLibrary.simpleMessage("Anuncio ahora"),
    "announcementExpired": MessageLookupByLibrary.simpleMessage(
      "Anuncios anteriores",
    ),
    "announcements": MessageLookupByLibrary.simpleMessage("boletín"),
    "back": MessageLookupByLibrary.simpleMessage("volver (o regresar)"),
    "cancel": MessageLookupByLibrary.simpleMessage("anulaciones"),
    "cancelSensitive": MessageLookupByLibrary.simpleMessage(
      "Desmarcar contenidos sensibles",
    ),
    "clear": MessageLookupByLibrary.simpleMessage("Clear"),
    "clip": MessageLookupByLibrary.simpleMessage("memo"),
    "clipCancelFavoriteText": MessageLookupByLibrary.simpleMessage(
      "¿Seguro que quieres cancelar la recogida?",
    ),
    "clipCreate": MessageLookupByLibrary.simpleMessage(
      "Nuevas notas adhesivas",
    ),
    "clipFavorite": MessageLookupByLibrary.simpleMessage("Añadir a favoritos"),
    "clipFavoriteList": MessageLookupByLibrary.simpleMessage(
      "Marcador (Internet)",
    ),
    "clipRemove": MessageLookupByLibrary.simpleMessage(
      "Eliminar notas adhesivas",
    ),
    "clipUpdate": MessageLookupByLibrary.simpleMessage(
      "Actualizar notas adhesivas",
    ),
    "clips": MessageLookupByLibrary.simpleMessage("memo"),
    "close": MessageLookupByLibrary.simpleMessage("关闭"),
    "confirmSelection": m0,
    "copyContent": MessageLookupByLibrary.simpleMessage("Copiar contenido"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Copiar enlace"),
    "copyRSS": MessageLookupByLibrary.simpleMessage("Copiar RSS"),
    "copyUserHomeLink": MessageLookupByLibrary.simpleMessage(
      "Copiar la dirección de la página de inicio del usuario",
    ),
    "copyUsername": MessageLookupByLibrary.simpleMessage(
      "Copiar nombre de usuario",
    ),
    "createFolder": MessageLookupByLibrary.simpleMessage("Nueva carpeta"),
    "createNote": MessageLookupByLibrary.simpleMessage(
      "Publicar un nuevo tema",
    ),
    "createNoteFormFile": MessageLookupByLibrary.simpleMessage(
      "Crear una entrada a partir de un fichero",
    ),
    "createNoteHint": MessageLookupByLibrary.simpleMessage("Lo que pasó..."),
    "createdDate": MessageLookupByLibrary.simpleMessage("Fecha de creación"),
    "creationFailedDialog": m1,
    "cw": MessageLookupByLibrary.simpleMessage("contenido oculto"),
    "day": MessageLookupByLibrary.simpleMessage("día"),
    "daysAgo": m2,
    "delete": MessageLookupByLibrary.simpleMessage("eliminar"),
    "deleteConfirm": m3,
    "deleteFileConfirmation": m4,
    "deleteFolderConfirmation": m5,
    "description": MessageLookupByLibrary.simpleMessage("descripciones"),
    "done": MessageLookupByLibrary.simpleMessage("cumplir"),
    "download": MessageLookupByLibrary.simpleMessage("descargando"),
    "drive": MessageLookupByLibrary.simpleMessage(
      "almacenamiento de archivos en la nube",
    ),
    "durationDay": m6,
    "durationHour": m7,
    "durationMinute": m8,
    "durationSecond": m9,
    "edit": MessageLookupByLibrary.simpleMessage("compilador"),
    "emoji": MessageLookupByLibrary.simpleMessage("emoticono"),
    "enterNewFileName": MessageLookupByLibrary.simpleMessage(
      "Introduzca un nuevo nombre de archivo",
    ),
    "enterNewTitle": MessageLookupByLibrary.simpleMessage(
      "Introduzca un nuevo título",
    ),
    "enterUrl": MessageLookupByLibrary.simpleMessage("Introduzca la URL"),
    "exceptionContentNull": MessageLookupByLibrary.simpleMessage(
      "El contenido no puede estar vacío",
    ),
    "exceptionCwNull": MessageLookupByLibrary.simpleMessage(
      "El contenido no puede estar vacío",
    ),
    "exceptionSendNote": m10,
    "explore": MessageLookupByLibrary.simpleMessage("descubrimientos"),
    "exploreHot": MessageLookupByLibrary.simpleMessage("de moda"),
    "exploreUserHot": MessageLookupByLibrary.simpleMessage("usuario popular"),
    "exploreUserLast": MessageLookupByLibrary.simpleMessage(
      "Usuarios conectados recientemente",
    ),
    "exploreUserPined": MessageLookupByLibrary.simpleMessage(
      "usuario que encabeza la lista",
    ),
    "exploreUserUpdated": MessageLookupByLibrary.simpleMessage(
      "Colaboradores recientes",
    ),
    "exploreUsers": MessageLookupByLibrary.simpleMessage("usuario"),
    "favorite": MessageLookupByLibrary.simpleMessage("Marcador (Internet)"),
    "filter": MessageLookupByLibrary.simpleMessage("Filter"),
    "folderName": MessageLookupByLibrary.simpleMessage("Nombre de la carpeta"),
    "follow": MessageLookupByLibrary.simpleMessage("enfoque"),
    "followed": MessageLookupByLibrary.simpleMessage("Siguió"),
    "followers": MessageLookupByLibrary.simpleMessage("observador"),
    "following": MessageLookupByLibrary.simpleMessage("Preocupado"),
    "fromCloud": MessageLookupByLibrary.simpleMessage("Desde el netbook"),
    "gotIt": MessageLookupByLibrary.simpleMessage("Got it!"),
    "hashtag": MessageLookupByLibrary.simpleMessage("hashtag"),
    "hostnames": MessageLookupByLibrary.simpleMessage("nombre de dominio"),
    "hour": MessageLookupByLibrary.simpleMessage("horas"),
    "hoursAgo": m11,
    "image": MessageLookupByLibrary.simpleMessage("fotografía"),
    "inputServer": MessageLookupByLibrary.simpleMessage(
      "Servidor de entrada manual",
    ),
    "insertDriverFile": MessageLookupByLibrary.simpleMessage(
      "Inserción de accesorios",
    ),
    "isFollowingYouNow": MessageLookupByLibrary.simpleMessage(
      "Te estoy observando.",
    ),
    "justNow": MessageLookupByLibrary.simpleMessage("recientemente"),
    "keepOriginal": MessageLookupByLibrary.simpleMessage(
      "Conservar la imagen original",
    ),
    "loadingServers": MessageLookupByLibrary.simpleMessage("Server Loading"),
    "local": MessageLookupByLibrary.simpleMessage("esta localidad"),
    "localUpload": MessageLookupByLibrary.simpleMessage("carga local"),
    "login": MessageLookupByLibrary.simpleMessage("Iniciar sesión"),
    "loginExpired": MessageLookupByLibrary.simpleMessage("登录信息已经过期，请重新登录"),
    "loginFailed": MessageLookupByLibrary.simpleMessage(
      "Fallo de inicio de sesión",
    ),
    "loginFailedWithAppCreate": MessageLookupByLibrary.simpleMessage(
      "Error de inicio de sesión: Error en la creación de la aplicación",
    ),
    "loginFailedWithToken": MessageLookupByLibrary.simpleMessage(
      "Error de inicio de sesión: error en la adquisición del token",
    ),
    "loginLoading": m12,
    "loginSuccess": MessageLookupByLibrary.simpleMessage(
      "Inicio de sesión correcto",
    ),
    "manageAccount": MessageLookupByLibrary.simpleMessage("Gestionar cuenta"),
    "markAsSensitive": MessageLookupByLibrary.simpleMessage(
      "Marcar como contenido sensible",
    ),
    "mention": MessageLookupByLibrary.simpleMessage("plantear (un tema)"),
    "minute": MessageLookupByLibrary.simpleMessage("minutos"),
    "minutesAgo": m13,
    "monthsAgo": m14,
    "more": MessageLookupByLibrary.simpleMessage("más"),
    "myCLips": MessageLookupByLibrary.simpleMessage("Mi nota."),
    "name": MessageLookupByLibrary.simpleMessage("nombre (de una cosa)"),
    "nameCannotBeEmpty": MessageLookupByLibrary.simpleMessage(
      "El nombre no puede estar vacío",
    ),
    "next": MessageLookupByLibrary.simpleMessage("el siguiente paso"),
    "noLists": MessageLookupByLibrary.simpleMessage(
      "You don\'t have any lists",
    ),
    "notFindServer": MessageLookupByLibrary.simpleMessage(
      "¿No ha encontrado su servidor?",
    ),
    "noteCopyLocalLink": MessageLookupByLibrary.simpleMessage(
      "Copie el enlace a este sitio",
    ),
    "noteCwHide": MessageLookupByLibrary.simpleMessage("guardar"),
    "noteCwShow": MessageLookupByLibrary.simpleMessage("Mostrar contenido"),
    "noteFormLanguageTranslation": m15,
    "noteLocalOnly": MessageLookupByLibrary.simpleMessage(
      "No participación conjunta",
    ),
    "noteOpenRemoteLink": MessageLookupByLibrary.simpleMessage(
      "Vaya al servidor anfitrión para visualizar",
    ),
    "notePined": MessageLookupByLibrary.simpleMessage("Top Posts"),
    "noteQuote": MessageLookupByLibrary.simpleMessage("cita"),
    "noteReNote": MessageLookupByLibrary.simpleMessage(
      "reenvío (correo, SMS, paquetes de datos)",
    ),
    "noteReNoteByUser": MessageLookupByLibrary.simpleMessage("Reenviado."),
    "noteTranslate": MessageLookupByLibrary.simpleMessage(
      "Traducción de entradas",
    ),
    "noteVisibility": MessageLookupByLibrary.simpleMessage("visibilidad"),
    "noteVisibilityFollowers": MessageLookupByLibrary.simpleMessage(
      "observador",
    ),
    "noteVisibilityFollowersText": MessageLookupByLibrary.simpleMessage(
      "Enviar sólo a seguidores",
    ),
    "noteVisibilityHome": MessageLookupByLibrary.simpleMessage(
      "fig. principio",
    ),
    "noteVisibilityHomeText": MessageLookupByLibrary.simpleMessage(
      "Timeline enviado sólo a la página de inicio",
    ),
    "noteVisibilityPublic": MessageLookupByLibrary.simpleMessage(
      "abiertamente",
    ),
    "noteVisibilityPublicText": MessageLookupByLibrary.simpleMessage(
      "Tu publicación aparecerá en la cronología global",
    ),
    "noteVisibilitySpecified": MessageLookupByLibrary.simpleMessage(
      "carta privada",
    ),
    "noteVisibilitySpecifiedText": MessageLookupByLibrary.simpleMessage(
      "Enviar sólo a los usuarios especificados",
    ),
    "notes": MessageLookupByLibrary.simpleMessage("tarjeta"),
    "notesCount": MessageLookupByLibrary.simpleMessage("Notes Count"),
    "notification": MessageLookupByLibrary.simpleMessage("notificaciones"),
    "notifications": MessageLookupByLibrary.simpleMessage("notificaciones"),
    "notifyAll": MessageLookupByLibrary.simpleMessage("completo"),
    "notifyFilter": MessageLookupByLibrary.simpleMessage("cribado"),
    "notifyFollowedAccepted": MessageLookupByLibrary.simpleMessage(
      "Su solicitud de atención ha sido aprobada.",
    ),
    "notifyFollowedYou": MessageLookupByLibrary.simpleMessage(
      "Tienes nuevos seguidores.",
    ),
    "notifyMarkAllRead": MessageLookupByLibrary.simpleMessage(
      "Marcar todo como leído",
    ),
    "notifyMention": MessageLookupByLibrary.simpleMessage("Hablando de mi"),
    "notifyMessage": MessageLookupByLibrary.simpleMessage("carta privada"),
    "notifyNotSupport": m16,
    "ok": MessageLookupByLibrary.simpleMessage("defina"),
    "openInNewTab": MessageLookupByLibrary.simpleMessage(
      "Ir a Visualización del navegador",
    ),
    "overviews": MessageLookupByLibrary.simpleMessage("hojear"),
    "pendingFollowRequest": MessageLookupByLibrary.simpleMessage(
      "Preocupación por la concesión de solicitudes",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("avances"),
    "previewNote": MessageLookupByLibrary.simpleMessage("Vista previa"),
    "processing": MessageLookupByLibrary.simpleMessage("en curso"),
    "public": MessageLookupByLibrary.simpleMessage("abiertamente"),
    "publish": MessageLookupByLibrary.simpleMessage("Correo electrónico:"),
    "reNoteHint": MessageLookupByLibrary.simpleMessage("Citando este post..."),
    "reNoteText": MessageLookupByLibrary.simpleMessage("Presupuesto"),
    "reaction": MessageLookupByLibrary.simpleMessage("respuesta"),
    "reactionAccepting": MessageLookupByLibrary.simpleMessage(
      "Aceptar respuestas Emoji",
    ),
    "reactionAcceptingAll": MessageLookupByLibrary.simpleMessage("completo"),
    "reactionAcceptingLikeOnly": MessageLookupByLibrary.simpleMessage(
      "Sólo me gusta",
    ),
    "reactionAcceptingLikeOnlyRemote": MessageLookupByLibrary.simpleMessage(
      "Sólo Kudos remotos",
    ),
    "reactionAcceptingNoneSensitive": MessageLookupByLibrary.simpleMessage(
      "Sólo contenido no sensible",
    ),
    "reactionAcceptingNoneSensitiveOrLocal":
        MessageLookupByLibrary.simpleMessage(
          "Sólo contenido no sensible (sólo gustos remotos)",
        ),
    "recipient": MessageLookupByLibrary.simpleMessage(
      "Para: (encabezamiento del correo electrónico)",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage(
      "refrescar (ventana del ordenador)",
    ),
    "registration": MessageLookupByLibrary.simpleMessage("Registration"),
    "registrationClosed": MessageLookupByLibrary.simpleMessage("closed"),
    "registrationOpen": MessageLookupByLibrary.simpleMessage("open"),
    "remote": MessageLookupByLibrary.simpleMessage("a distancia"),
    "rename": MessageLookupByLibrary.simpleMessage("renombrar"),
    "renameFile": MessageLookupByLibrary.simpleMessage("Renombrar archivo"),
    "renameFolder": MessageLookupByLibrary.simpleMessage(
      "Cambiar el nombre de una carpeta",
    ),
    "replyNoteHint": MessageLookupByLibrary.simpleMessage(
      "Responder a este post...",
    ),
    "replyNoteText": MessageLookupByLibrary.simpleMessage(
      "Responder a un mensaje",
    ),
    "saveFailed": MessageLookupByLibrary.simpleMessage("no salvar"),
    "saveImage": MessageLookupByLibrary.simpleMessage("Guardar imagen"),
    "saveSuccess": MessageLookupByLibrary.simpleMessage("Salvar con éxito"),
    "search": MessageLookupByLibrary.simpleMessage("buscar algo"),
    "searchAll": MessageLookupByLibrary.simpleMessage("completo"),
    "searchHost": MessageLookupByLibrary.simpleMessage(
      "Especifique el nombre de dominio",
    ),
    "searchLocal": MessageLookupByLibrary.simpleMessage("este sitio"),
    "searchRemote": MessageLookupByLibrary.simpleMessage("a distancia"),
    "searchServers": MessageLookupByLibrary.simpleMessage("Search Servers"),
    "secondsAgo": m17,
    "selectHashtag": MessageLookupByLibrary.simpleMessage(
      "Seleccionar etiqueta",
    ),
    "selectServer": MessageLookupByLibrary.simpleMessage(
      "Please Select Your Server",
    ),
    "selectUser": MessageLookupByLibrary.simpleMessage("Seleccionar usuario"),
    "sensitiveClickShow": MessageLookupByLibrary.simpleMessage(
      "Haga clic para mostrar",
    ),
    "sensitiveContent": MessageLookupByLibrary.simpleMessage(
      "Contenido sensible",
    ),
    "serverAddr": MessageLookupByLibrary.simpleMessage(
      "dirección del servidor",
    ),
    "serverList": MessageLookupByLibrary.simpleMessage("List of Servers"),
    "settings": MessageLookupByLibrary.simpleMessage("establecer"),
    "share": MessageLookupByLibrary.simpleMessage(
      "compartir (alegrías, ventajas, privilegios, etc.) con los demás",
    ),
    "showConversation": MessageLookupByLibrary.simpleMessage("Ver diálogo"),
    "somebodyNote": MessageLookupByLibrary.simpleMessage(" puestos"),
    "timeline": MessageLookupByLibrary.simpleMessage("cronología"),
    "timelineGlobal": MessageLookupByLibrary.simpleMessage(
      "situación de seguridad",
    ),
    "timelineHome": MessageLookupByLibrary.simpleMessage("fig. principio"),
    "timelineHybrid": MessageLookupByLibrary.simpleMessage("socialización"),
    "timelineLocal": MessageLookupByLibrary.simpleMessage("esta localidad"),
    "translate": MessageLookupByLibrary.simpleMessage("renderización"),
    "uncategorized": MessageLookupByLibrary.simpleMessage("Sin categoría"),
    "unfollow": MessageLookupByLibrary.simpleMessage("Dejar de seguir"),
    "updatedDate": MessageLookupByLibrary.simpleMessage(
      "Fecha de actualización",
    ),
    "uploadFailed": m18,
    "uploadFromUrl": MessageLookupByLibrary.simpleMessage(
      "Cargar desde el sitio web",
    ),
    "user": MessageLookupByLibrary.simpleMessage("usuario"),
    "userAll": MessageLookupByLibrary.simpleMessage("completo"),
    "userDescriptionIsNull": MessageLookupByLibrary.simpleMessage(
      "Este usuario aún no se ha presentado",
    ),
    "userFile": MessageLookupByLibrary.simpleMessage(
      "archivo adjunto (correo electrónico)",
    ),
    "userHot": MessageLookupByLibrary.simpleMessage("usuario"),
    "userNote": MessageLookupByLibrary.simpleMessage("tarjeta"),
    "userRegisterBy": MessageLookupByLibrary.simpleMessage("registrado en"),
    "userWidgetUnSupport": MessageLookupByLibrary.simpleMessage(
      "Lista de widgets (inacabada)",
    ),
    "username": MessageLookupByLibrary.simpleMessage("ID de usuario"),
    "usersCount": MessageLookupByLibrary.simpleMessage("Users Count"),
    "video": MessageLookupByLibrary.simpleMessage("vídeo"),
    "view": MessageLookupByLibrary.simpleMessage("comprobar"),
    "viewMore": MessageLookupByLibrary.simpleMessage("Ver más"),
    "vote": MessageLookupByLibrary.simpleMessage("referéndum"),
    "voteAllCount": m19,
    "voteCount": m20,
    "voteDueDate": MessageLookupByLibrary.simpleMessage("fecha límite"),
    "voteEnableMultiChoice": MessageLookupByLibrary.simpleMessage(
      "Votos múltiples permitidos",
    ),
    "voteExpired": MessageLookupByLibrary.simpleMessage(
      "Se cierra la votación.",
    ),
    "voteNoDueDate": MessageLookupByLibrary.simpleMessage("permanentemente"),
    "voteOptionAtLeastTwo": MessageLookupByLibrary.simpleMessage(
      "El número de votos no puede ser inferior a dos",
    ),
    "voteOptionHint": m21,
    "voteOptionNullIndex": m22,
    "voteResult": MessageLookupByLibrary.simpleMessage(
      "Se han generado los resultados de las votaciones",
    ),
    "voteWillExpired": m23,
    "yearsAgo": m24,
  };
}
