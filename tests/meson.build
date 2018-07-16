if get_option('enable-tests')

  test_deps = [ ims_deps ]

  #test('image-router',
  #  executable('image-router-test', 'image-router-test.vala',
  #    dependencies: test_deps
  #  )
  #)

  test('pipeline',
    executable('pipeline-test', 'pipeline-test.vala',
      dependencies: test_deps
    )
  )

endif
