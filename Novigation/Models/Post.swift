//
//  Post.swift
//  Novigation
//
//  Created by Александр Хмыров on 05.09.2022.
//

import Foundation


struct Post1: ModelPost {
    var author: String = "AleksandrSiberia"

    var image: String = "post1"

    var description: String = "🥇 Золотой пост для родителей. Запомните 5 правил, соблюдение которых сделает будущее вашего ребёнка счастливее.    \n\n 1. НЕ РАЗДРАЖАЙТЕСЬ НА РЕБЕНКА. Раздражение родителей на своего ребёнка действует как проклятие. Преподобный Паисий Святогорец говорит: 'Знайте, что проклятие, даже (просто) негодование родителей действуют очень сильно. И даже, если родители не проклинали своих детей, а просто пришли из-за них в возмущение, то у детей нет потом ни одного светлого дня в их жизни: вся их жизнь одно сплошное мучение. Потом такие дети очень страдают всю земную жизнь.'       \n\n 2. ВМЕСТО ОСУЖДЕНИЯ РЕБЕНКА ПОДДЕРЖИВАЙТЕ И БЛАГОСЛОВЛЯЙТЕ ЕГО. Родители не имеют права осуждать ребёнка. Наоборот, мы должны говорить ему только добрые слова, советы, поддерживать и благословлять. Преподобный Паисий Святогорец говорит: 'Мы имеем право только сказать: «Спаси тебя Господи, сохрани тебя Господи, помоги тебе Господи, и я в тебя верю, что у тебя все получится, я рад, что ты принял самостоятельное решение, но надо было посоветоваться со мной… и все в таком духе (положительном)'.      \n\n 3. НЕ ВИНИТЕ РЕБЕНКА, ВИНИТЕ СЕБЯ. Причиной плохого поведения ребёнка является негативный пример его родителей. Мы сами своим плохим влиянием очерняем чистую душу ребёнка. Преподобный Паисий Святогорец говорит: 'Дитя по своей природе безвинный ангел и, если у него отклонения из-за воспитания плохого, то причина в нас.'      \n\n 4. ВОСПИТЫВАЙТЕ ПРЕЖДЕ ВСЕГО СЕБЯ, А НЕ РЕБЕНКА. Исправить плохое поведение ребёнка возможно только своим добрым примером. Ребёнок исправится только тогда, когда мы сами исправляем свои грехи. Преподобный Паисий Святогорец учит: 'Ищите грех у себя и искореняйте. Очистив себя, автоматически очищается и ребенок.'      \n\n 5. МОЛИТЕСЬ О ДЕТЯХ КАЖДЫЙ ДЕНЬ. Даже если вы нарушили предыдущие 4 правила, ваша сердечная молитва к Господу и раскаяние могут всё сгладить и убрать негативные последствия на будущее ребёнка. Преподобный Паисий Святогорец говорит: 'Молитва матери о детях своих разгоняет всех бесов от них (беса пьянства, беса курения, беса блуда и т.д.). Молитва матери достанет дитя со дна ада. Плачьте за своих детей, матери, а не проклинайте и Господь все устроит.'"

    var likes: Int = 0

    var views: Int = 0
}
var post1 = Post1()



struct Post2: ModelPost {
    var author: String = "AleksandrSiberia"

    var image: String = "post2"

    var description: String = "Пройдя путь тренировок без 'химии' более 25 лет и получив профессиональное фитнес образование, я полностью перешёл на тренировки с весом собственного тела, потому что поднятие тяжестей вредит организму, не развивает тело функционально и вижу хорошие результаты от своей системы тренировок.    \n\n 1. ВРЕД ОТ ПОДНЯТИЯ ТЯЖЕСТЕЙ: ТРАВМЫ СУСТАВОВ. В современном фитнесе наращивание мышц происходит за счёт регулярного увеличения веса штанги, гантелей, это приводит к воспалению и изнашиванию суставов, травмам. Пройдя обучение на семинаре врачей травматологии, главные клиенты которых - это люди, тренирующиеся с отягощениями, меня со 100% уверили, что поднятие веса больше веса собственного тела изнашивает суставы и калечит людей. Наоборот, тренировки с собственным телом защищают от этого риска и укрепляют суставы.    \n\n 2 .ЛИШНИЙ ЖИР. Бодибилдинг, пауэрлифтинг и лишний жир - это верные друзья. Люди, поднимающие тяжести употребляют излишние калории ради роста мышц и часто набирают 10-15 кг жира и больше, ведь лишний вес не мешает поднимать штангу. Потом сушатся, используя низкокалорийные диеты, которые гробят гормональный фон и метаболизм. Наоборот, когда вы тренируетесь со своим телом, каждый лишний килограмм мешает выполнять упражнения и организм адаптируется к нагрузке с помощью уменьшения количества жира, снижая аппетит, это доказано обширной практикой.    \n\n 3. РАЗРЫВЫ. НЕГАРМОНИЧНОЕ РАЗВИТИЕ МЫШЦ. При поднятии тяжестей происходит не естественная нагрузка для человека от которой развитие мышц опережает развитие связок и сухожилий, это приводит к их растяжению и разрыву, а сама фигура приобретает неестественные формы. Наоборот, когда вы тренируетесь с собственным телом, в первую очередь укрепляется и оздоравливается связочный аппарат.     \n\n 4. ОТСУТСТВИЕ ФУНКЦИОНАЛЬНЫХ КАЧЕСТВ. Попросите 'здоровика' из зала подтянуться на одной руке несколько раз, почти никто не сможет, это говорит об отсутствии функциональной силы, ловкости, которая пригождается в жизни, в самообороне, в отличии от поднятия тяжестей"


    var likes: Int = 0

    var views: Int = 0
}
var post2 = Post2()

struct Post3: ModelPost {
    var author: String = "Aleksandr"

    var image: String = "post3"

    var description: String = "Дети - наше сокровище, они доверяют нам всем сердцем, учатся у нас, подражая нам. Сокровище, которое ищет доброту, любовь в мире, в семье, а когда не находит становится несчастным. Нет больше ответственности в жизни, чем родительская ответственность за детей. Приведу слова святителя Иоанна Златоуста: «Нерадение о детях – больший из всех грехов, он приводит к крайнему нечестию».     \n\n Поэтому родители, которые не заботятся о благочестии детей считаются убийцами душ своих детей.  Святитель Иоанна Златоуст говорит: «Те отцы, которые не заботятся о достоинстве и скромности детей, хуже детоубийц, поскольку губят их души»     \n\n Для того, чтобы спасти душу ребёнка от таких родителей, Бог забирает её. Преподобный Симеон Новый Богослов предупреждает: «Если родители не оказывают должного попечения о детях, не учат их разуму, не внушают им добрых правил, то души детей будут взысканы от рук их».     Родители стараются накормить своих детей и часто при этом не обучают детей благочестию. Я считаю, это одна из главных причин постоянной нехватки денег у таких семей, причина разлада в делах и работе у родителей. Святитель Николай Сербский говорит: «Старайтесь не о куске хлеба для детей своих, старайтесь о душе и совести. И не будут нуждаться дети ваши, и вы благословенны будете на земле и небесах».      \n\n Я уверен, что счастье детей не зависит от того, какое мирское образование дали им родители или какой капитал, а зависит от добродетели родителей, которую они передают своим детям. Святитель Иоанн Златоуст говорит: «Не будем заботиться о том, чтобы собрать богатство и оставить его детям; будем учить их добродетели и просить им благословение от Бога. Вот это, именно это – величайшее неизреченное сокровище, неоскудевающее богатство, с каждым днем приносящее все больше даров».      \n\n Я считаю, что счастье моих детей напрямую зависит от того, насколько я соблюдают Божьи заповеди. Я уверен, из-за грехов родителей будут страдать дети, а из-за добродетелей родителей они будут счастливы так как всё это передаётся от родителей к детям. Антоний Оптинский (Путилов) говорит - “...они (дети) страждут это за грехи и невоздержание родителей.”"

    var likes: Int = 0

    var views: Int = 0
}
var post3 = Post3()

struct Post4: ModelPost {
    var author: String = "Aleksandr"

    var image: String = "post4"

    var description: String = "Расскажу премудрости, которые защищают людей и семьи.     \n\n 1. НЕ ССОРЬСЯ С СИЛЬНЫМ. Не ссорьтесь с людьми, обладающими властью по закону, начальниками, а также людьми, занимающими высокое положение в обществе или имеющими другие возможности негативно повлиять на вашу жизнь. Премудрый Сын Сирахов горит: “Не ссорься с человеком сильным, чтобы когда-нибудь не впасть в его руки.” (Сирах 8;1)      \n\n 2. НЕ СУДИСЬ С БОГАТЫМИ. Деньги всегда решали и решают многое, а не справедливость. Сирах 8;2-3 : “Не заводи тяжбы с человеком богатым, чтобы он не имел перевеса над тобою; ибо золото многих погубило, и склоняло сердца царей.”     \n\n 3. НЕ СПОРЬ С ДЕРЗКИМ. Не связывайтесь с такими людьми, если не хотите проблем на пустом месте. Сирах 8;4: “Не спорь с человеком, дерзким на язык, и не подкладывай дров на огонь его.”      \n\n4. НЕ ШУТИ С НЕВЕЖДОЮ. У них нет моральных рамок, если не хотите окунуться в грязь, держите их от себя и семьи на максимальной дистанции. Сирах 8;5: “Не шути с невеждою, чтобы не подверглись бесчестию твои предки.”      \n\n 5. НЕ ЗАНИМАЙ ДЕНЬГИ БОЛЕЕ СИЛЬНОМУ ЧЕМ ТЫ.  Можно оказаться виноватым в том, что тебе должны и ощутишь пренебрежение сильного на себе, вместо возврата долга. Сирах 8;15: “Не давай взаймы человеку, который сильнее тебя; а если дашь, то считай себя потерявшим.”      \n\n 6. НЕ ДОВЕРЯЙ ЧУЖИМ. Не делись важной информацией с не близкими людьми, не верь их словам, а проверяй. Сирах 8;21-22: “При чужом не делай тайного, ибо не знаешь, что он сделает. Не открывай всякому человеку твоего сердца, чтобы он дурно не отблагодарил тебя.”      \n\n 7. НЕ ИМЕЙ ГЛУПЫХ ДРУЗЕЙ. Такие люди не сохраняют тайны. Сирах 8;20: “Не советуйся с глупым, ибо он не может умолчать о деле.”     \n\n 8. НЕ ССОРЬСЯ И НЕ ОБЩАЙСЯ С АГРЕССИВНЫМИ. Для них жизнь человека ничто. Сирах 8;19: “Не заводи ссоры со вспыльчивым и не проходи с ним чрез пустыню; потому что кровь — как ничто в глазах его, и где нет помощи, он поразит тебя.”     \n\n 9. НЕ СОГЛАШАЙСЯ БЫТЬ ПОРУЧИТЕЛЕМ В КРЕДИТАХ. Не берите на семью риск бедности из-за чужих долгов. Сирах 29;20: “Поручительство привело в разорение многих достаточных людей и пошатнуло их, как волна морская;”"
    
    var likes: Int = 0

    var views: Int = 0
}
var post4 = Post4()


var arrayModelPost: [ModelPost] = [post1, post2, post3, post4]




