# -*- coding: utf-8; mode: tcl; tab-width: 4; indent-tabs-mode: nil; c-basic-offset: 4 -*- vim:fenc=utf-8:ft=tcl:et:sw=4:ts=4:sts=4

options    mlz.github.project    \
           mlz.github.author     \
           mlz.github.tag        \
           mlz.github.tar

proc mlz.port {name {version 0}} {
    name           $name
    description    $name
    maintainers    benmelz
    version        $version
    platforms      darwin
}

proc mlz.github {project author tag} {
    global name distname extract.suffix mlz.github.author mlz.github.project mlz.github.tag mlz.github.tar

    mlz.github.project    ${project}
    mlz.github.author     ${author}
    mlz.github.tag        ${tag}
    mlz.github.tar        "https://github.com/${mlz.github.author}/${mlz.github.project}/tarball/${mlz.github.tag}"

    distname              ${name}
    distfiles             ${distname}${extract.suffix}

    fetch {
       try -pass_signal {
           curl fetch ${mlz.github.tar} "${distpath}/${distfiles}.TMP"
           file rename -force "${distpath}/${distfiles}.TMP" "${distpath}/${distfiles}"
           set fetched 1
       } catch {{*} eCode eMessage} {
           ui_debug [msgcat::mc "Fetching distfile from %s failed: %s" ${mlz.github.tar} ${eMessage}]
           set lastError ${eMessage}
       } finally {
           file delete -force "${distpath}/${distfiles}.TMP"
       }

       if {![info exists fetched]} {
           if {${lastError} ne ""} {
               error ${lastError}
           } else {
               error [msgcat::mc "fetch failed"]
           }
       }
   }

   checksum { }
}

