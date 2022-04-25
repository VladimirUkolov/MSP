﻿
#Область ПрограммныйИнтерфейс

// Возвращает новое сообщение.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ТипТелаСообщения - ТипОбъектаXDTO - тип тела сообщения которое требуется создать.
//
// Возвращаемое значение:
//  ОбъектXDTO - объект требуемого типа.
//  
Функция НовоеСообщение(Знач ТипТелаСообщения) Экспорт
КонецФункции

// Отправляет сообщение
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  Сообщение - ОбъектXDTO - сообщение.
//  Получатель - ПланОбменаСсылка.ОбменСообщениями - получатель сообщения.
//  Сейчас - Булево - отправить сообщений через механизм быстрых сообщений.
//
Процедура ОтправитьСообщение(Знач Сообщение, Знач Получатель = Неопределено,
		Знач Сейчас = Ложь) Экспорт
КонецПроцедуры

// Получает список обработчиков сообщений по пространству имен.
// @skip-warning ПустойМетод - особенность реализации.
// 
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * Канал - Строка - Канал сообщения.
//    * Обработчик - ОбщийМодуль - Обработчик сообщения.
//  ПространствоИмен - Строка - uri пространства имен в котором определены типы тел сообщений.
//  ОбщийМодуль - ОбщийМодуль - Общий модуль в котором содержатся обработчики сообщений.
// 
Процедура ПолучитьОбработчикиКаналовСообщений(Знач Обработчики,
		Знач ПространствоИмен, Знач ОбщийМодуль) Экспорт
КонецПроцедуры

// Выполняет доставку быстрых сообщений.
// @skip-warning ПустойМетод - особенность реализации.
//
Процедура ДоставитьБыстрыеСообщения() Экспорт
КонецПроцедуры

// Возвращает тип, являющийся базовым для всех типов тел сообщений в модели сервиса.
// @skip-warning ПустойМетод - особенность реализации.
//
// Возвращаемое значение:
//  ТипОбъектаXDTO - базовый тип тел сообщений в модели сервиса.
//
Функция ТипТело() Экспорт
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// @skip-warning ПустойМетод - особенность реализации.
Процедура УстановитьКлючОбластиПриВосстановленииИзВыгрузки(Сообщение) Экспорт	
КонецПроцедуры

// Читает сообщение из нетипизированного тела сообщения.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  НетипизированноеТело - Строка - нетипизированное тело сообщения.
//
// Возвращаемое значение:
//  ОбъектXDTO - {http://www.1c.ru/SaaS/Messages}Message - сообщение.
//
Функция ПрочитатьСообщениеИзНетипизированногоТела(Знач НетипизированноеТело) Экспорт
КонецФункции

// Возвращает имя канала сообщений соответствующего типу сообщения.
// @skip-warning ПустойМетод - особенность реализации.
//
// Параметры:
//  ТипСообщения - ТипОбъектаXDTO - тип сообщения удаленного администрирования.
//
// Возвращаемое значение:
//  Строка - имя канала сообщений соответствующее переданному типу сообщения.
//
Функция ИмяКаналаПоТипуСообщения(Знач ТипСообщения) Экспорт	
КонецФункции

#КонецОбласти

