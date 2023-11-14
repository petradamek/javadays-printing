package com.petradamek.doklady;

import org.apache.fop.apps.Fop;
import org.apache.fop.apps.FopFactory;
import org.apache.xmlgraphics.util.MimeConstants;

import javax.xml.transform.Result;
import javax.xml.transform.Source;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.sax.SAXResult;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.awt.Desktop;
import java.io.BufferedOutputStream;
import java.io.OutputStream;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Map;

/**
 * Hello world!
 */
public class Main {

    private static final Path outputDir = Paths.get(System.getProperty("user.home") + "/doklady");

    public static void main(String[] args) throws Exception {

        Files.createDirectories(outputDir);

        URL doklady = getResource("doklady.xml");
        Source input = new StreamSource(doklady.toString());

        URL configuration = getResource("/myfop.xconf");
        FopFactory fopFactory = FopFactory.newInstance(configuration.toURI(), configuration.openStream());

        processTemplate("doklady-A6.xsl", "doklady", input, fopFactory);
    }

    public static void processTemplate(final String templateName, final String outFileName, Source input, FopFactory fopFactory) throws Exception {
        processTemplate(templateName, outFileName, input, fopFactory, Map.of());
    }

    public static void processTemplate(
            final String templateName, final String outFileName,
            Source input, FopFactory fopFactory,
            Map<String, Object> params) throws Exception {
        processTemplate(templateName, outFileName, input, fopFactory, true, params);
    }

    public static void processTemplate(
            final String templateName, final String outFileName,
            Source input, FopFactory fopFactory,
            boolean showResult,
            Map<String, Object> params

    ) throws Exception {

        Path outFile = outputDir.resolve(outFileName + ".pdf");
        Path foFile = outputDir.resolve(outFileName + ".xml");

        URL templateUrl = getResource(templateName);
        Source template = new StreamSource(templateUrl.toString());

        TransformerFactory factory = TransformerFactory.newInstance("net.sf.saxon.BasicTransformerFactory", Main.class.getClassLoader());
        Transformer transformer = factory.newTransformer(template);

        params.forEach(transformer::setParameter);

        try (OutputStream out = new BufferedOutputStream(Files.newOutputStream(foFile))) {
            Result foResult = new StreamResult(out);
            transformer.transform(input, foResult);
        }

        try (OutputStream out = new BufferedOutputStream(Files.newOutputStream(outFile))) {
            Fop fop = fopFactory.newFop(MimeConstants.MIME_PDF, out);
            Result foResult = new SAXResult(fop.getDefaultHandler());
            transformer.transform(input, foResult);
        }

        if (showResult) {
            Desktop.getDesktop().open(outFile.toFile());
        }
    }

    private static URL getResource(String name) {
        URL resource = Main.class.getResource(name);
        if (resource == null) {
            throw new IllegalArgumentException("Resource not found: " + name);
        }
        return resource;
    }
}
