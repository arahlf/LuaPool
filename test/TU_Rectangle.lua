package.path = package.path .. ";../?.lua"

require 'lunit'
require 'rectangle'

module('TU_Rectangle', package.seeall, lunit.testcase)

function testContains()
    local rectangle = Rectangle(0, 0, 5, 3)

    assert_true(rectangle:contains(0, 0))
    assert_true(rectangle:contains(1, 1))
    assert_true(rectangle:contains(5, 3))

    assert_false(rectangle:contains(0, -1))
    assert_false(rectangle:contains(-1, 0))
    assert_false(rectangle:contains(5, 4))
    assert_false(rectangle:contains(6, 3))
end